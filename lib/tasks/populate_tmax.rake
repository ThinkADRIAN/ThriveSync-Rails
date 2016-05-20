def t_max_cards_text
  [
    "Feeling down or sad for a few days is normal. If your sadness doesn't go away, it might be a symptom of depression, and you should contact your doctor.",
    "It’s normal to worry or feel nervous. Be sure to talk to your doctor, though, if you feel very worried or nervous most days and this makes it hard to live your life.",
    "If you worry all the time or have a very serious fear, it could be a sign of an anxiety disorder. There is help. Start by talking to your doctor.",
    "Try this. Sit down, close your eyes, take deep breaths. Let your mind go blank. If you have a thought, breathe again, and let it go. Do this for 5 minutes, or as long as you can.",
    "Exercise can boost your mood and give you more energy. You’ll benefit most from 35 minutes a day 5 times a week, but even a little bit could help.",
    "Eating healthy foods can fuel your body and boost your mood. Eat plenty of vegetables, fruits, whole grains, and low-fat protein. For healthy tips and tricks, visit nutrition.gov.",
    "Try keeping a thought journal. When you have a negative thought, write it down. Then, challenge that thought or think of a positive thought to replace it. Be sure to write that down, too.",
    "Feeling stressed? Sit down and close your eyes. Breathe in through your nose and out through your mouth. Now, take ten slow, deep breaths.",
    "Start small! You can take a 10-minute walk later today and aim for a longer walk next time.",
    "Late nights and early mornings are some of the hardest times to stay psychologically and emotionally focused. Try to set a healthy sleep routine, and stick to it.",
    "Diet does wonders! Try to create a more sustainable kind of energy by eating small and healthy snacks at regular intervals throughout the day.",
    "Short “microbursts” during the day can help refresh and revitalize you. Make time for a minute of movement or a change of scenery.",
    "Exercise has been proven to cause release of “feel good” endorphins into the brain. It also helps distract from negative thoughts. Give it a shot, if you’re stuck in a rut.",
    "Have you hung out with a friend lately? Social interaction can help boost feelings of personal satisfaction, and overall positive mood.",
    "Give yourself permission to close your computer and put down your phone a few hours before bed. Avoiding the screens will help tell your body you’re ready for a full and restful night of sleep.",
    "Tracking your mood during highs and lows will give you a more accurate picture of what keeps you feeling grounded and good!",
    "If you have any symptoms of depression—feeling sad for weeks, sleep changes, or loss of focus at work or school—be sure to talk to your doctor.",
    "Tough day? Call a friend or spend time with a loved one. Being around other people can boost your mood, and friends can give you the support you might need.",
    "Keep track of how you feel and look for changes in your emotions. If you ever need help, you’re not alone. Talk to you doctor or call 1-800-662-4357.",
    "If you have anxiety or depression, you’re not alone. Almost one in five Americans is affected by anxiety or depression. To get help, call 1-800-662-4357.",
    "Getting help for anxiety or depression? The doctor will ask you about your feelings, medical, and family history. Being honest can help them help you.",
    "If you ever think about hurting yourself or committing suicide, find help right away. Call the doctor, 911, or go the emergency room. You can also call the National Suicide Prevention Lifeline at 1-800-273-8255.",
    "Living with depression or anxiety may feel embarrassing, but it shouldn't have to be that way. If you're having a hard time, talk to someone and get help.",
    "Maybe you’ve been feeling down for a while, or have been more worried than usual. See a doctor if this gets worse, or you start having trouble living your normal life.",
    "By doing things to lift your mood, you are taking charge of your recovery. Take note of what makes you feel good, so you can seek out other similar things to do!",
    "Meditation is an easy way to stay calm and feel good. Try it when you have a few free minutes!",
    "Don't forget: Relaxation techniques can help you feel better. Try a few minutes of peaceful meditation!",
    "Sometimes medication is used to treat depression or anxiety, but it’s not for everyone. Only your doctor can say if it’s right for you.",
    "Try meditating a little every day. Meditation takes practice. As you get more comfortable, it will become easier and help you feel even better.",
    "Walking is a great way to help with symptoms of anxiety! Even a 10-minute walk can improve your mood.",
    "Walking is a great way to help with symptoms of anxiety! You will get the most benefit by walking for at least 30 minutes. If able, walk longer to feel your best!",
    "How about a quick 10-minute walk tomorrow at lunch? Remember, even a 10-minute walk can improve your mood!",
    "Exercise keeps you healthy and boosts your mood. Think of a few activities you can try. Which sounds the most fun? If you find fun ways to exercise, you'll be more likely to stick with it.",
    "When you notice a worried thought, evaluate it. Is it logical? Is it likely? Will everything probably turn out ok?",
    "Ask yourself if you have any control over what’s worrying you. If you do, take steps to help. If not, practice relaxing or focus on something you do control.",
    "Getting the right amount of sleep will help with your recovery. By getting 7 to 9 hours of sleep each night, you can improve not only your anxiety, but also your overall health.",
    "Make a list of tasks you need to accomplish today, and write down step-by-step what must be done to complete them. Do your tasks seem easier to tackle now? If not, try reaching out to your [support person], maybe he or she can help.",
    "Good job on tracking your mood lately! Keep up the good work, and remember that you can reach out to your [support person] if you need support.",
    "Your mood impacts how you feel about your abilities. By tracking your mood, you’re actively taking steps toward feeling better about yourself and what you can accomplish.",
    "Are you sharing any data with your enrolled supporter? Sharing your mood data enables your supporter to see how you’re doing, and encourage you to keep up the good work.",
    "Remember that you can add more than one supporter, using ThriveSync. Add an additional person for extra support!"
  ]
end

namespace :db do
  desc "Populate T-Max Cards"
  task :populate_tmax => :environment do
    PreDefinedCard.delete_all

    texts = t_max_cards_text

    texts.each do |text|
      pre_defined_card = PreDefinedCard.new
      pre_defined_card.text = text
      pre_defined_card.category = 'NIH'
      pre_defined_card.save!
    end
  end
end