# TODO: Dockerfile parser should be used.
def workdir
  File.readlines('Dockerfile.dev').each do |line|
    return line.split(' ')[1] if line.match(/^WORKDIR /)
  end
end

desc "Build Docker image"
task :build do
  sh "docker build -t flashcards:dev -f Dockerfile.dev ."
end

desc "Run the container"
task :run do
  sh "docker run --rm -v #{Dir.pwd}:#{workdir} -it flashcards:dev #{ARGV[1..-1].join(' ')}"
end

desc "Run shell within the container"
task :sh do
  sh "docker run --rm -v #{Dir.pwd}:#{workdir} --entrypoint /bin/bash -it flashcards:dev"
end

desc "Delete all the Docker containers and images"
task :prune do
  sh "docker rm $(docker ps -a -q)"
  sh "docker rmi $(docker images -q)"
end
