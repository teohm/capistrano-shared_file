unless Capistrano::Configuration.respond_to?(:instance)
    abort "capistrano/shared_files requires Capistrano 2"
end

if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.load do

    # ================================================================
    # This variable defines files to be symlinked from shared path.
    #
    # File 'config/database.yml' is added by default, to cover 80%
    # of the use cases. Please OVERWRITE this to fit your needs.
    # ================================================================
    _cset :shared_files, %w(config/database.yml)

    # ================================================================
    # These variables define where to store the shared files.
    # Make sure you understand the implication when you modify them.
    # ================================================================
    _cset :shared_file_dir, "files"
    _cset(:shared_file_path) { File.join(shared_path, shared_file_dir) }


    # ================================================================
    # Cap tasks are added under namespace deploy:shared_file:*
    # Usually you do not need to call them directly, as they are
    # triggered during deploy:setup and deploy.
    # ================================================================
    namespace :deploy do
      namespace :shared_file do

        desc <<-DESC
          Generate shared file dirs under shared/files dir.

          For example, given:
            set :shared_files, %w(config/database.yml db/seeds.yml)

          The following directories will be generated:
            shared/files/config/
            shared/files/db/
        DESC
        task :setup, :except => { :no_release => true } do
          if exists?(:shared_files)
            dirs = shared_files.map {|f| File.join(shared_file_path, File.dirname(f)) }
            run "#{try_sudo} mkdir -p #{dirs.join(' ')}"
            run "#{try_sudo} chmod g+w #{dirs.join(' ')}" if fetch(:group_writable, true)
          end
        end
        after "deploy:setup", "deploy:shared_file:setup"


        desc <<-DESC
          Print a reminder to upload shared files \
          along with scp samples.
        DESC
        task :print_reminder do
          if exists?(:shared_files)
            servers = find_servers(:no_release => false)
            puts <<-INFO
  *************************
  *  UPLOAD SHARED FILES  *

   Remember to upload these files:
     #{ shared_files.join('\n  ') }

   To '#{shared_file_path}' in server(s):
     #{servers.join('\n  ')}

   SCP Samples:
            INFO

            servers.each do |server|
              shared_files.each do |file_path|
                puts "    scp #{file_path} #{server}:#{File.join(shared_file_path, file_path)}\n"
              end
            end

            puts <<-INFO

  *************************
            INFO
          end
        end
        after "deploy:setup", "deploy:shared_file:print_reminder"


        desc <<-DESC
          Symlink shared files to release path.

          WARNING: It DOES NOT warn you when shared files not exist.  \
          So symlink will be created even when a shared file does not \
          exist.
        DESC
        task :create_symlink, :except => { :no_release => true } do
          (shared_files || []).each do |path|
            run "ln -nfs #{shared_file_path}/#{path} #{release_path}/#{path}"
          end
        end
        after "deploy:finalize_update", "deploy:shared_file:create_symlink"

      end # namespace shared_file
    end # namespace deploy

  end
end
