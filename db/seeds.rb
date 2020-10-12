query = <<SQL
INSERT INTO "users" ("id", "name", "username", "age", "bio", "password_digest", "gender", "city", "state", "country", "motto", "url", "last_seen_at") VALUES
('1', 'Tom', 'Tom', '37', 'I''m Tom and I''m here to help you. Send me a message if you''re confused by anything.   <font size="1" color="green"><b>Before asking me a question, please check the <a href="https://web.archive.org/web/20090318060735/http://www.myspace.com/Modules/Help/Pages/HelpCenter.aspx" target="_new">FAQ</a> to see if your question has already been answered.</b></font> <br><br>  I may have been on your friend list when you signed up. If you don''t want me to be, click "Edit Friends" and remove me!  <br><br><b>Also, feel free to tell me what features you want to see on MySpace and if I think it''s cool, we''ll do it!</b>', '$2a$12$eLGS56/CepNXkXdaunm5O.63/yhUp/6RWg2f3Z/NQfDaVNsA3KMLK', 'male', 'Santa Monica', 'California', 'United States', ':-)', 'tom', '2020-10-06 01:26:50.228335');
SQL
ActiveRecord::Base.connection.execute(query)
@user = User.find_or_create_by(id: 1)
img = Images.new
image_path = Pathname.new(File.expand_path('../app/public/images/tom.jpeg', __FILE__))
img.image  = File.open(image_path) #carrierwave uploads using params here
img.user = @user
img.save!
