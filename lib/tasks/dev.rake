task sample_data: :environment do
  p "Creating sample data"

#  id                     :bigint           not null, primary key
#  comments_count         :integer          default(0)
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer          default(0)
#  photos_count           :integer          default(0)
#  private                :boolean          default(TRUE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :citext
#  created_at             :datetime         not null
#  updated_at             :datetime         not null

  if Rails.env.development?
    FollowRequest.destroy_all
    User.destroy_all
    
  end

  12.times do
    name = Faker::Name.first_name

    u = User.create(
      email: "#{name}@example.com",
      username: name,
      password: "password",
      private: [true, false].sample
    )


    # p u.errors.full_messages
  end
  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end

  users.each do |user|
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::Quote.jack_handey,
        image: "https://robohash.org/#{rand(9999)}"
      )

      user.followers.each do |follower|
        if rand < 0.5
          photos.fans << follower # pushing follower into the fans collection of the Photo
        end

        if rand < 0.25
          photo.comments.create(
            body: Faker::Quote.jack_handey,
            author: follower
          )
        end
      end
    end
  end

  p "#{User.count} users created"

  p "#{FollowRequest.count} follow requests created"

end