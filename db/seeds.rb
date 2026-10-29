# Seeds "Tom" (user 1). Every new user is welcomed and friended by him (see
# #tomswelcome in users_controller.rb), so the app breaks without him.
# Profile data is taken from Tom's archived profile, www.myspace.com/tom,
# as captured on May 15, 2005. Safe to run more than once.

tom = User.find_or_initialize_by(id: 1)
tom.assign_attributes(
  name: 'Tom',
  username: 'Tom',
  url: 'tom',
  age: 29,
  gender: 'male',
  city: 'Santa Monica',
  state: 'California',
  country: 'United States',
  motto: 'woo!! :)',
  bio: <<~HTML.strip,
    I'm here to help you with <b>MySpace</b>. Send me a message if you're confused by anything.

    <font size="1" color="green"><b>Before asking me a question, please check the <a href="https://web.archive.org/web/2005/http://www.myspace.com/misc/faq.html" target="_new">FAQ</a> to see if your question has already been answered.</b></font> <br><br>

    I may have been on your friend list when you signed up. If you don't want me to be, click "Edit Friends" and remove me!  <br><br><b>Also, feel free to tell me what features you want to see on MySpace and if I think it's cool, we'll do it!</b><br><br>

    If you want a tutorial on HTML/designing your page, check this out: <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewprofile&amp;friendid=812799">Mack</a>!! <br><br>

    Note: If you try to view my friends list you won't see all 11,000,000 people. This was bogging down the system, so we made it only show 40 people. So you wont be able to see the friends on my list.<br><br>
  HTML
  who_id_like_to_meet: "I'd like to meet people who educate, inspire or entertain me... I have a few close friends I've known all my life. I'd like to make more. <br>",
  interests_general: 'Internet, Movies, Reading, Dancing, Karaoke, Baseball, Language, Culture, History of Communism, Philosophy, Singing/Writing Music, Running, Finding New Food, Weight Lifting, Hiking, WWI Aviation, Travel, Building alternate communities<br><br>',
  interests_music: <<~HTML.strip,
    <b>Bands</b>: Beatles, Superdrag, Jackson 5, Weezer, Sex Pistols, The Carpenters, Vain, Radiohead, Teenage Fanclub, Rocket from the Crypt, Pitchfork, Oasis, Rialto, Supergrass, Travis, The Doors, Cheap Trick, Simple Plan, Alice Cooper, KISS,  A*TEENS, The Beach Boys, The Velvet Underground, Journey
    <p>
    <b>Solo Artists</b>: Billy Joel, Bruce Springsteen, Elvis, Brendan Benson, David Bowie, Rick Springfield, Barry Manilow, Paul Stanley Solo Album, Bob Dylan, Rod Stewart
    </p><p>
    <b>Singers</b>: Michael Jackson (age 14 &amp; under), Karen Carpenter, Whitney Houston (particularly The Bodyguard soundtrack), George Michael, Louie Louie, Stevie Rachelle ("Tuff"), Davy Vain, Coco Lee, Robin Zander, singer from "Taz" &amp; "Cyclone Sound", Frank Sinatra, Steve Perry
    </p><p>
    <b>Albums</b>: <i>Appetite for Destruction</i> - Guns &amp; Roses; <i>Life</i> - The Cardigans; <i>A Hard Day's Night</i> - The Beatles; <i>Dookie</i> - Green Day; <i>Blue</i> - Weezer; <i>One Missisipi</i> - Brendan Benson; <i>Two Steps from the Move</i> - Hanoi Rocks; Led Zeppelin I,  The Doors, <i>In The Valley of Dying Stars</i> - SuperDrag; Survivor <i>When Seconds Count</i> - Rick Springfield, <i>Working Class Dog</i>
    </p><p>
    <b>Instruments</b>: The Er Hu, Piano, certain guitar tones (Rocket from the Crypt, Sex Pistols, Rolling Stones)
    </p><p>
    <b>MySpace Artists</b>: <a href="https://web.archive.org/web/2005/http://www.myspace.com/limbeck">Limbeck</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/butchwalker">Butch Walker</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=1727147">The Fictions</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=1805287">The Ettes</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=283552">Feable Weiner</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=454827">Billionaire Boys Club</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=1323677">Halfway Home</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=224370">The Pacific</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=1908688">The Honorary Title</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=2217026">Stranded Alone</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=2125578">Kill Hannah</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/falloutboy">FallOutBoy</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=827726">Melee</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/theshore">The Shore</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/thesummerobsession">The Summer Obsession</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/kino">Kino</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/carybrothers">Cary Brothers</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/thevolunteers">The Volunteers</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/index.cfm?fuseaction=user.viewProfile&amp;friendID=3245004&amp;Mytoken=20041028125146">The Howl</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/headautomatica">Head Automatica</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/seelfresh">Seel Fresh</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/jupitersunrise">Jupiter Sunrise</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/keane">Keane</a>, <a href="https://web.archive.org/web/2005/http://www.myspace.com/sayanything">Say Anything</a> !</p>
  HTML
  interests_movies: '<b>Films</b>: Lawrence of Arabia, Ben Hur, Patton, Spartacus, Gandhi, The 10 Commandments, Apocalypse Now, Beauty &amp; The Beast (the cartoon), Thin Red Line, Titanic, Gladiator, The Patriot, Breakfast at Tiffanys, Un Coeur en Hiver, To Live, Happy Times, The Road Home, Not One Less, Ju Dou, Red Sorghum, The Empire of the Sun, Gone With the Wind, The Godfather, 2001, Clockwork Orange, Blade Runner, Deer Hunter, Mean Streets, Grease, Urban Cowboy, Saturday Night Fever, The Sound of Music, Copland, Xiu Xiu, Dances With Wolves<br><br><b>Directors</b>: Kubrick, Francis Copolla, Zhang Yimou, Anh Hung Tran, Steven Spielberg',
  interests_television: 'Tuned out. <b>Except for SF Giants.</b> I rented Band of Brothers and liked that.',
  interests_books: 'History, Non-Fiction, How-To, George Orwell (mainly the essays), Milan Kundera, The Birth of Tragedy, Untimely Meditations, Beyond Good &amp; Evil, A Story Like the Wind',
  interests_heroes: 'Lee Kuan Yew,  Friedrich Nietzsche, Laurens van der Post, George Orwell, Frederick Dolan (Prof. of Rhetoric, UCB), Lawrence of Arabia, My Mom',
  status: 'Single',
  here_for: 'Dating, Serious Relationships, Friends, Networking',
  hometown: 'San Diego',
  height: %q(5' 11"),
  body_type: 'Average',
  ethnicity: 'White / Caucasian',
  zodiac_sign: 'Scorpio',
  smoke: 'No',
  drink: 'No',
  education: "I'm an open book",
  occupation: 'MySpace',
  networking: "Nightlife - Marketing - Promoter\nPublishing - Writer - Non-fiction",
  last_login_at: Time.utc(2005, 5, 14, 19, 35)
)
tom.password_digest ||= '$2a$12$eLGS56/CepNXkXdaunm5O.63/yhUp/6RWg2f3Z/NQfDaVNsA3KMLK'
tom.save!

if tom.images.empty?
  img = Images.new
  img.image = File.open(File.expand_path('../../app/public/images/tom2005.jpg', __FILE__))
  img.user = tom
  img.save!
end

if tom.schools.empty?
  tom.schools.create!(name: 'University Of California-Los Angeles', location: 'Los Angeles, CALIFORNIA', grad_year: '2000',
                      student_status: 'Alumni', degree: "Master's Degree", major: 'Film - Critical Studies',
                      start_year: '1999', end_year: '2000')
  tom.schools.create!(name: 'University Of California-Berkeley', location: 'Berkeley, CALIFORNIA', grad_year: '1997',
                      student_status: 'Alumni', degree: "Bachelor's Degree", major: 'English &amp; Rhetoric',
                      clubs: 'DECAL: Literary Theory', start_year: '1993', end_year: '1996')
end

if tom.companies.empty?
  tom.companies.create!(name: 'MySpace.Com', location: 'Los Angeles, California, US', start_year: '2003')
end

if tom.blog_entries.empty?
  # Oldest first. Only the titles survive in the 2005 capture.
  ['MySpace Oahu Party Number 2!', 'Taste of Chaos - Vote for Bands!', 'Hawaiian Spring Break with MySpace',
   'usernames / URLs woo !', "I'm in Boston, Hot Import Nights"].each_with_index do |subject, i|
    tom.blog_entries.create!(subject: subject, body: '', created_at: Time.utc(2005, 4, 1) + (i * 9).days)
  end
end
