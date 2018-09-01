desc "set up dev machine locally"
task :run_dev_machine_locally do
  system 'ansible-playbook -i "localhost," -c local dev-machine.yml --ask-sudo-pass'
end

desc "set ssh landing machine"
task :setup_ssh_landing do
  system "ansible-playbook -i hosts --ask-sudo-pass --limit ssh-landing ssh-landing.yml"
end

desc "set up cron container"
task :setup_cron_container do
  system "ansible-playbook -i hosts --ask-sudo-pass --limit cron cron-container.yml"
end
