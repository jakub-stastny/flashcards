# TODO: Dockerfile parser should be used.
def workdir
  File.readlines('Dockerfile').each do |line|
    return line.split(' ')[1] if line.match(/^WORKDIR /)
  end
end

desc "Build Docker image"
task :build do
  sh "docker build . -t flashcards"
end

desc "Run the container"
task :run do
  sh "docker run --rm -v #{Dir.pwd}:#{workdir} -it flashcards run"
end

desc "Run shell within the container"
task :sh do
  sh "docker run --rm -v #{Dir.pwd}:#{workdir} --entrypoint /bin/bash -it flashcards"
end
