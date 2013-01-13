system "git remote add git@heroku.com:lang-trainer.git"

known_hosts = File.expand_path("~/.ssh/config")

File.open(known_hosts, "a") do |f|
  f.puts <<-EOF
Host heroku.com
   StrictHostKeyChecking no
   CheckHostIP no
   UserKnownHostsFile=/dev/null
  EOF
end