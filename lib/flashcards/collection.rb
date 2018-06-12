# frozen_string_literal: true

require 'yaml'
require 'forwardable'

# flashcards = Collection.new(Flashcard, 'es.yml')
# flashcards << flashcard
# flashcards.save
module Flashcards
  class Collection
    def self.data_file_dir
      Pathname.new("~/Dropbox/Data/Data/Flashcards").expand_path
    end

    def initialize(item_class, basename)
      @path = self.class.data_file_dir.join("#{basename}.yml")
      @item_class, @activity_filters = item_class, Hash.new
    end

    def items
      @items ||= self.load_raw_collection.map do |data|
          @item_class.new(data)
      rescue StandardError => error
          abort "Loading item #{data.inspect} failed: #{error.message}.\n\n#{error.backtrace}"
      end
    end

    def active_items
      return self.items if @activity_filters.empty?

      @activity_filters.keys.reduce(self.items) do |items, filter_name|
        self.run_filter(filter_name, items)
      end
    end

    def run_filter(filter_name, items)
      items.select { |item| @activity_filters[filter_name].call(item) }
    end

    def filter(filter_name, &block)
      @activity_filters[filter_name] = block if block
      self
    end

    def filter_out(filter_name, &block)
      @activity_filters[filter_name] = Proc.new { |item| !block.call(item) } if block
      self
    end

    def filters
      @activity_filters.keys
    end

    def has_filter?(filter_name)
      @activity_filters.key?(filter_name)
    end

    def filtered_out_items(filter_name)
      self.items - self.run_filter(filter_name, self.items)
    end

    # flashcards[:expressions, 'hacer']
    # flashcards[:translations, :silent_translations, 'to be']
    def [](key, value)
      self.items.select do |item|
        [item.send(key)].flatten.include?(value)
      end
    end

    extend Forwardable

    # Generally we want to avoid proxying methods, unless
    # it is clear whether they would be performed on items or active_items.
    def_delegator :items, :<<

    def replace(original_item, new_item)
      index = self.items.index(original_item)
      self.delete(original_item)
      self.items.insert(index, new_item)
    end

    def delete(flashcard)
      self.items.delete(flashcard)
    end

    def save
      return if self.items.empty?

      if File.mtime(@path.to_s) > @loaded_at
        raise "Cannot be saved #{File.mtime(@path.to_s).inspect} vs. #{@loaded_at.inspect}"
      end

      self.save_to(@path) && self.save_to(self.back_up_path)

      @loaded_at = Time.now # Otherwise the next save call with fail.
      true
    end

    def save_to(path)
      updated_data = self.to_yaml
      if !File.exist?(path) || File.read(path) != updated_data
        path.open('w') do |file|
          file.write(updated_data)
        end
        return true
      else
        return false
      end
    end

    def back_up_path
      chunks    = @path.basename.to_s.split('.')
      timestamp = Time.now.strftime('%Y-%m-%d-%H-%M')
      basename  = chunks.insert(-2, timestamp).join('.')

      self.class.data_file_dir.join('Backups', basename)
    end

    def to_yaml
      self.items.map(&:data).to_yaml
    end

    # TODO: Should we deprecate this?
    # It's best to use explicit .items/.active_items calls.
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
