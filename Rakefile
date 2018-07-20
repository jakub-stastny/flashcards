desc "Build Docker image"
task :build do
  sh "docker build . -t flashcards"
end

desc "Run the container"
task :run do
  sh "docker run --rm -v #{Dir.pwd}:/app -it flashcards"
end

desc "Run shell within the container"
task :sh do
  sh "docker run --rm -v #{Dir.pwd}:/app -it flashcards bash"
end
