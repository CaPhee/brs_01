every 30.day, at: "0:00am" do
  rake "admin:remove_processed_request"
end
every 1.minutes do
  rake "admin:remove_processed_request"
end
