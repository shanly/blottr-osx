
schema '0001 initial' do

  entity 'Page' do
    string :title

    has_many :notes
  end

  entity 'Note' do
    string :content
    integer32 :width
    integer32 :height
    integer32 :x
    integer32 :y

    belongs_to :page
  end

  # Examples:
  #
  # entity "Person" do
  #   string :name, optional: false
  #
  #   has_many :posts
  # end
  #
  # entity "Post" do
  #   string :title, optional: false
  #   string :body
  #
  #   datetime :created_at
  #   datetime :updated_at
  #
  #   has_many :replies, inverse: "Post.parent"
  #   belongs_to :parent, inverse: "Post.replies"
  #
  #   belongs_to :person
  # end

end
