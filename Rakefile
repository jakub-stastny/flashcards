# frozen_string_literal: true

# TODO: Dockerfile parser should be used.
def workdir
  File.readlines('Dockerfile.dev').each do |line|
    return line.split(' ')[1] if line =~ /^WORKDIR /
  end
end

def volumes
  [
    "#{Dir.pwd}:#{workdir}",
    "#{ENV['HOME']}/.config/flashcards.yml:#{environment[:FLASHCARDS_CONFIG_FILE]}",
    "#{ENV['HOME']}/.local/share/flashcards:#{environment[:FLASHCARDS_DATA_DIR]}"
  ]
end

def environment
  {
    FLASHCARDS_CONFIG_FILE: '/root/.config/flashcards.yml',
    FLASHCARDS_DATA_DIR: '/root/.local/flashcards'
  }
end

def docker(command)
  command = "docker run --rm #{volumes.map { |v| "-v #{v}" }.join(' ')} #{environment.map { |var, value| "-e #{var}:#{value}" }.join(' ')} -it flashcards:dev #{command}"
  puts command; exec command
end

desc "Build Docker image"
task :build do
  sh "docker build -t flashcards:dev -f Dockerfile.dev ."
end

desc "Run the container"
task :run do
  docker(ARGV[1..-1].join(' '))
end

desc "Run shell within the container"
task :sh do
  docker('sh')
end

desc "Run the tests"
task :test do
  docker('bundle exec rspec')
end

desc "Run Rubocop"
task :rubocop do
  sh "rake run 'bundle exec rubocop --auto-correct'"
end

desc "Delete all the Docker containers and images"
task :prune do
  sh "docker rm $(docker ps -a -q)"
  sh "docker rmi $(docker images -q)"
end
