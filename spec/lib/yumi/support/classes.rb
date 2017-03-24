class Game
  attr_accessor :id, :title, :rating,
                :levels, :characters

  def initialize(id)
    @id = id
    @title = 'Super Game'
    @rating = '10'
    @levels = [Level.new('1', 10), Level.new('2', 20)]
    @characters = [Character.new('1')]
  end
end

class Level
  attr_accessor :id, :title, :number

  def initialize(id, _number)
    @id = id
    @title = 'Super Level'
    @number = id
  end
end

class Character
  attr_accessor :id, :name, :level_number

  def initialize(id)
    @id = id
    @name = 'John Doe'
    @level_number = 1
  end
end

module Fake
  class GamePresenter < ::Yumi::Base
    type 'game'
    attributes :title, :rating
    has_many :levels, :characters
    links :self
  end

  class LevelPresenter < ::Yumi::Base
    type 'level'
    attributes :title, :number
    links :self
  end

  class CharacterPresenter < ::Yumi::Base
    type 'character'
    attributes :name, :level_number
    links :self
  end
end
