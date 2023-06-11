class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
  end
  
end
