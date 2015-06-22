
def rnd_string
  (0...5).map { ('a'..'z').to_a[rand(26)] }.join
end