json.extract! @answer, :id, :content, :created_at, :updated_at, :user_id
json.rating (@answer.rating)