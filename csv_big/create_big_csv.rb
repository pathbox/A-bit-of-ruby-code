require 'csv'
require_relative './print_helper'

headers = ['id', 'name', 'email', 'city', 'street', 'country']

name    = "Pink Panther"
email   = "pink.panther@example.com"
city    = "Pink City"
street  = "Pink Road"
country = "Pink Country"

title = "my title"
content = %Q(Washington (CNN)The ever-turbulent 2016 election is now just plain weird.
The attack on an Orlando gay nightclub -- the worst strike on U.S. soil since 9/11 -- spurred a strange week of politics even by this year's standards.
As always, Donald Trump was at the epicenter of much of the controversy. The presumptive Republican nominee, who opposes same-sex marriage, sought to portray himself as a "real friend" of the LGBT community while taking ambiguous positions on gun control that he later seemed to reverse and insinuating President Barack Obama has ulterior motives in responding to terrorism.
Hillary Clinton&#39;s life in the spotlight
Photos: Hillary Clinton's life in the spotlight
Hillary Clinton, meanwhile, broke with Obama by uttering the words "radical Islamism" -- rhetoric that she has long resisted for fear that it would embolden terrorists.
How the GOP could cut ties with Donald Trump
Terrorist attacks often have the potential to radically shift the political conversation. Trump's proposed temporary ban on Muslim immigrants in the aftermath of the San Bernardino, California, attacks, for instance, deeply resonated with GOP primary voters. But the responses this week -- in which Trump and Clinton made moves that would have been unexpected a week ago -- reflect the unusual confluence of gay rights, gun control and national security in the wake of Orlando and underscore the volatile nature of American politics this year.
Trump
No one is more unusual at the moment than Trump.
He started the week by tearing up the Terrorism 101 rule book used by most politicians who go out of their way to foster unity in the wake of such an outrage. Trump did the exact opposite.
Donald Trump&#39;s empire
Photos: Donald Trump's empire
Hours after Sunday's attack unfolded, he issued a self-congratulatory tweet that noted his long stance that radical Islam leads to terrorism. On Monday, he implied Obama was somehow complicit or sympathetic toward the U.S.-born Muslim who went on the rampage and later snatched away the campaign credentials of The Washington Post when it reported on his comments.
Trump has never been known for consistency and demonstrated his ability to hold several contradictory positions on issues that motivate the Republican base at the same time.
GOP Rep. Fred Upton: I won't endorse 'off track' Trump
After the Orlando carnage, Trump suggested that if the people in the nightclub had guns themselves, the story could have been different. And he stirred his audiences with false claims that Clinton wanted to "take away Americans' guns."
But then, perhaps scenting a change in the political wind, Trump said he would meet with the National Rifle Association to discuss how to stop people on the terror watch list or FBI no-fly lists from buying guns, in contradiction with previous Republican positions. But during a Thursday rally in Dallas, he again seemed to take a hard line on guns, repeating his claim about Clinton and saying, "I'm going to save your Second Amendment rights."
Trump repeatedly claimed that he was the best friend the LGBT community has in this election -- rather than Clinton who has been deeply engaged in LGBT issues for years and counts the community as a deep well of support and donor dollars.
Clinton could not resist trolling her general election foe when CNN reporter Phil Mattingly quoted Trump on Twitter as saying: "You tell me: who is better for the gay community and who is better for women than Donald Trump."
The former secretary of state's campaign account tweeted back, "Hi."
Hi. https://t.co/11Fyyf5IQm

 Hillary Clinton (@HillaryClinton) June 17, 2016
Trump expounded further on his gun views Friday evening. At a Texas rally Trump argued, as he often has in the wake of terrorist attacks and mass shootings, that fewer gun restrictions would have lessened the death toll.
"If we had people, where the bullets were going in the opposite direction, right smack between the eyes of this maniac," Trump said, gesturing between his eyes. "And this son of a b---- comes out and starts shooting and one of the people in that room happened to have (a gun) and goes boom. You know what, that would have been a beautiful, beautiful sight, folks."
Trump also slammed President Barack Obama for arguing for action to change existing gun laws in the wake of the mass shooting in Orlando.
"President Obama is trying to make terrorism into guns and it's not guns, folks. It is not guns, folks. It is not guns, this is terrorism," Trump said.
Role reversal
But Trump was not the only politician pulling off a role reversal toward the gay community.
Iowa Rep. Steve King, who once warned his state could become a "gay marriage Mecca" after its Supreme Court lifted a ban on same-sex marriage, offered a striking shift in tone this week.
"I think it was clear that gays were targeted in Orlando and it does matter and it's tragic that they were targeted because of their sexual orientation," King told CNN's Chris Cuomo on "New Day."
That was a rare moment of conciliation in what was a largely divisive political week.
In fact, the manner in which the Orlando attack immediately became political fodder contrasted with the numbing wave of shock that settled over the United Kingdom, where campaigning for next week's Europe Union referendum was put on hold after the murder of lawmaker Jo Cox.
Donald Trump tests the limits of his showman style
Trump and Clinton were hardly alone in the political fray this week.
With seven months left in his term, Obama could have left it to the newly minted Democratic presumptive nominee to carry the fight to Trump. But he felt a need to respond -- especially to Trump's comments.
"That's not the America we want," he said during an extraordinarily direct speech on Tuesday. "It doesn't reflect our democratic ideals. It will make us less safe."
By wading so deeply into the presidential race, Obama was offering a preview of the kind of political assist he could provide Clinton as he hits the campaign trail soon as a surrogate. But on Tuesday at least, Obama completely overshadowed his preferred successor.
Capitol Hill
The normal order is also disrupted on Capitol Hill.
Republican leaders are stuck in an uncomfortable marriage with their can't-live-with-him, can't-live-without-him presidential nominee, who is showing no signs of cooling the polarizing rhetoric that many GOP elites decry.
Lawmakers normally attracted to microphones like bees around a honey pot spent the week fleeing in the opposite direction. House Speaker Paul Ryan endured the latest round of questions about whether he would withdraw his recent endorsement of Trump.
Collins hopes for compromise in new gun control bill
Ryan tried to explain his dilemma in an interview that will air on NBC's "Meet the Press" on Sunday.
"I get that this is a very strange situation. He's a very unique nominee," Ryan said. "But I feel as a responsibility institutionally as the speaker of the House that I should not be leading some chasm in the middle of our party."
Democrats have their problems too: they have a presidential candidate, Bernie Sanders, who has clearly lost the race but again this week refused to quit.
Sanders is proving that piloting a soft landing to a political revolution is tough. While he vowed on Thursday to help Clinton defeat Trump, he still wants full reform of the Democratic Party and its policy platform.
Still, there are signs that Sanders is losing his leverage, not gaining it: even one of his closest backers, Rep. Tulsi Gabbard, signaled on Friday that the game was up.
"I think there is a Democratic nominee at this point," Gabbard told CNN's Wolf Blitzer, though would not go as far as endorsing Clinton.
Arizona Sen. John McCain also felt the political heat when blasted Obama as "directly responsible" for the mass shooting in Orlando.
Then, like a character from a previous, more courtly political age, he had second thoughts, and issued a statement that clarified that he meant that the President's policies were to blame -- rather than the character of the man who beat him for the White House eight years ago.
A politician who admits he was wrong. In the crazed world of the 2016 presidential election circus, what could be weirder than that?)
author = "author"
country = "China"
age = 30

print_memory_usage do
  print_time_spent do
    CSV.open('data.csv', 'w', write_headers: true, headers: headers) do |csv|
      5_000_0.times do |i|
        puid = Time.now.to_i.to_s
        csv << [i+1, title,content,author,country,age,puid]
      end
    end
  end
end
