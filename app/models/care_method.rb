class CareMethod < ApplicationRecord
  has_and_belongs_to_many :symptoms
  has_many :user_care_histories, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  serialize :video_links, Array
  serialize :video_titles, Array

  def video_links_and_titles=(links_and_titles)
    links_and_titles_list = links_and_titles.split("\r\n")
    self.video_links = []
    self.video_titles = []

    links_and_titles_list.each do |item|
      link, title = item.split(", ")
      self.video_links << link.strip
      self.video_titles << title.strip
    end
  end

  def video_links_and_titles
    self.video_links.zip(self.video_titles).map { |link, title| "#{link}, #{title}" }.join("\r\n")
  end
end
