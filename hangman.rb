# frozen_string_literal: true

require 'msgpack'
require 'yaml'

# Implementation of the hangman game in ruby
class Hangman
    TRIES = 21
    attr_accessor :word, :used_characters, :tries

    def initialize(word, used_characters: [], tries: TRIES)
        @word = word
        @used_characters = used_characters
        @tries = tries
    end

    def play
        tries.downto 1 do |try|
            char = ask(try) while used_characters.include?(char)
            used_characters << char

            break if won

            save(try)
        end

        if won
            puts "Congratulations!! You have won. The word was #{word}"
        else
            puts "You have lost, the word was #{word}"
        end

        clear_save
    end

    def self.load
        data = File.open('save', 'r') { |file| MessagePack.unpack file.read }
        return unless data

        Hangman.new(data[0], used_characters: data[1], tries: data[2])
    rescue StandardError
        nil
    end

    private

    def ask(try)
        puts "Letters you have used: #{used_characters.join(' ')}"
        puts "You have #{try} tries", hidden_word
        gets.chomp.downcase[0]
    end

    def hidden_word
        word.split('').map { |char| used_characters.include?(char) ? char : '_' }.join ''
    end

    def won
        !hidden_word.include? '_'
    end

    def save(try)
        File.open('save', 'w') { |f| f.print MessagePack.dump([word, used_characters, try - 1]) }
    end

    def clear_save
        File.open('save', 'w') { |f| f.print '' }
    end
end

word = File.open('words.yaml', 'r') { |f| YAML.safe_load(f.read).sample }

hangman = Hangman.load || Hangman.new(word)
hangman.play
