require 'yaml'

# flashcards = Collection.new(Flashcard, 'es.yml')
# flashcards << flashcard
# flashcards.save
#
# TODO: Don't save if this version is older than mtime of the file.
# TODO: Backups.
module Flashcards
  class Collection
    def self.data_file_dir
      Pathname.new("~/Dropbox/Data/Data/Flashcards").expand_path
    end

    def initialize(item_class, basename, &activity_filter)
      @path = self.class.data_file_dir.join("#{basename}.yml")
      @item_class, @activity_filter = item_class, activity_filter
    end

    def items
      @items ||= self.load_raw_collection.map do |data|
        begin
          @item_class.new(data)
        rescue => error
          abort "Loading item #{data.inspect} failed: #{error.message}.\n\n#{error.backtrace}"
        end
      end
    end

    def active_items
      return self.items unless @activity_filter

      self.items.select do |item|
        @activity_filter.call(item)
      end
    end

    def inactive_items
      self.items - self.active_items
    end

    # flashcards[:expression, 'hacer']
    def [](key, value)
      self.items.select do |item|
        [item.send(key)].flatten.include?(value)
      end
    end

    def <<(item)
      self.items << item
    end

    def save
      return if self.items.empty?

      if File.mtime(@path.to_s) > @loaded_at
        raise "Cannot be saved #{File.mtime(@path.to_s).inspect} vs. #{@loaded_at.inspect}"
      end

      @path.open('w') do |file|
        file.puts(self.to_yaml)
      end
    end

    def to_yaml
      self.items.map(&:data).to_yaml
    end

    include Enumerable

    def each(&block)
      if block
        self.active_items.each(&block)
      else
        self.active_items.to_enum
      end
    end

    protected
    def load_raw_collection
      @loaded_at = Time.now

      # YAML treats an empty string as false.
      raw_items_list = YAML.load_file(@path.to_s) || Array.new
    rescue Errno::ENOENT
      Array.new
    end
  end
end
