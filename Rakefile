desc "test in a docker container"
task :docker_run do
  system 'docker run -it --mount type=bind,source="$(pwd)",target=/home/grant/dev-machine archlinux:v2'
end

desc "set up dev machine locally"
task :run_dev_machine_locally do
  system 'ansible-playbook arch-dev-machine.yml --ask-become-pass'
end

desc "set ssh landing machine"
task :setup_ssh_landing do
  system "ansible-playbook -i hosts --ask-sudo-pass --limit ssh-landing ssh-landing.yml"
end

desc "set up cron container"
task :setup_cron_container do
  system "ansible-playbook -i hosts --ask-sudo-pass --limit cron cron-container.yml"
end

desc "set up syncthing"
task :setup_syncthing do
  system "ansible-playbook -i hosts --ask-sudo-pass --limit syncthing syncthing.yml"
end

# assumes efs is already populated with things
desc "Set up a mail server on ec2 -- ensure GRANT_PASSWORD and EFS_FILESYSTEM_ID are set "
task :setup_mailserver do
  system %{"ansible-playbook -i hosts mail.yml --skip-tags "mail-master"}
end
