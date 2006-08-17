# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "FIXME"
set :repository,  "https://svn.dev.pdx.netroedge.com:8752/#{application}/trunk"

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

role :web, "FIXME"
role :app, "FIXME"
role :db,  "FIXME", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "FIXME"
set :user,      "FIXME"
set :use_sudo,  false

# =============================================================================
# TASKS
# =============================================================================

task :deploy, :roles => [:app, :db, :web] do
  transaction do
    # put up the maintenance screen
    ENV['REASON'] = 'an application upgrade'
    ENV['UNTIL']  = Time.now.+(600).strftime("%H:%M %Z")
    disable_web
    
    # update the code
    update_code
    
    # fix the symlink
    symlink
    
    # run migrations
    migrate
  end
  
  # restart the server
  restart
  
  # remove the maintenance screen
  enable_web  
end

desc "Update all servers with the latest release of the source code."
task :update_code, :roles => [:app, :db, :web] do
  on_rollback { delete release_path, :recursive => true }

  #puts "doing my update_code"
  temp_dest= "tmp_code"

  #puts "...get a local copy of the code into #{temp_dest} from local svn"
  # but this could also just be your local development folder
  system("svn export -q #{configuration.repository} #{temp_dest}")
  system("mv #{temp_dest}/config/database.yml.deploy #{temp_dest}/config/database.yml")
  system("chmod 600 #{temp_dest}/config/database.yml")

  #puts "...tar the folder"
  # you could exclude files here that you don't want on your production server
  system("tar -C #{temp_dest} -c -z -f code_update.tar.gz .")

  #puts "...Sending tar file to remote server"
  put(File.read("code_update.tar.gz"), "code_update.tar.gz")

  #puts "...detar code on server"
  run <<-CMD
  mkdir -p #{release_path} &&
  tar -C   #{release_path} -x -z -f code_update.tar.gz &&
  rm -f    code_update.tar.gz &&
  rm -rf   #{release_path}/log #{release_path}/public/system &&
  ln -nfs  #{shared_path}/log #{release_path}/log &&
  ln -nfs  #{shared_path}/system #{release_path}/public/system &&
  chmod 600 #{release_path}/config/database.*
  CMD

  #puts "...cleanup"
  system("rm -rf #{temp_dest} code_update.tar.gz")
end

task :restart, :roles => :app do
  run "#{current_path}/script/process/reaper --dispatcher=dispatch.fcgi"
end