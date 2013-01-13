known_hosts = File.expand_path("~/.ssh/config")

File.open(known_hosts, "a") do |f|
  f.puts <<-EOF
Host github.com
   StrictHostKeyChecking no
   CheckHostIP no
   UserKnownHostsFile=/dev/null
  EOF
end