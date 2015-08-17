json.extract! @question, :id, :title, :content, :created_at, :updated_at, :user_id
json.rating (@question.rating)