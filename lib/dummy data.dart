import 'dart:math';

class TypingTestHelper {
  static final List<String> dummyTexts = [
    "the quick brown fox jumps over the lazy dog this is a classic example sentence used for typing practice and to demonstrate the beauty of the english language it contains every letter of the alphabet making it a useful tool for testing is sentence can help improve typing proficiency and keyboard familiarity and is often used in typing tests and exercises over time as you get more accustomed to typing this sentence you will notice an improvement in your overall ",
    "lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut u fugiat nulla pariatur this text has been ",
    'where program right when take child should own who against thing still you may would begin first what not while at same during fact interest part world might by need want part get these feel run become could off both give lead too against about world by look in over what this but when can now by life how come same another have down form life very other about thing state and with go good lead go look may then such the school head on same by those interest ',
    "a journey of a thousand miles begins with a single step the world is full of challenges and opportunities embrace each moment with courage and determination success comes to those who are willing to take risks and push beyond their comfort zones believe in yourself and keep moving forward life is a series of steps and each step brings us closer to our goals and dreams keep striving and never give up every challenge you face is an opportunity to gr",
    "to be or not to be that is the question whether tis nobler in the mind to suffer the slings and arrows of outrageous fortune or to take arms against a sea of troubles and by opposing end them to die to sleep no more and by a sleep to say we end the heartache and the thousand natural shocks that flesh is heir to this passage reflects the profound existential questions and dilemmas faced by individuals throughout history it delves into themes",
    "in the beginning god created the heavens and the earth and the earth was without form and void and darkness was upon the face of the deep and the spirit of god moved upon the face of the waters and god said let there be light and there was light and god saw the light that it was good and god divided the light from the darkness this passage is a fundamental part of the creation narrative in the judeo christian tradition it describes the orig",
    "it was the best of times it was the worst of times it was the age of wisdom it was the age of foolishness it was the epoch of belief it was the epoch of incredulity it was the season of light it was the season of darkness it was the spring of hope it was the winter of despair we had everything before us we had nothing before us we were all going direct to heaven we were all going direct the other way this excerpt captures the essence of ",
    "the sun rose slowly as if it had been sleeping in the birds began their early morning songs filling the air with melodies that danced on the breeze the world seemed to stretch and yawn waking up to the promise of a new day the city below buzzed with activity as people started their daily routines each one moving with purpose and determination the light of dawn cast a golden hue over everything signaling the start of another vibrant day ",
    "in a quiet corner of the world far removed from the hustle and bustle of modern life there existed a serene and tranquil village the villagers lived simple yet fulfilling lives tending to their fields nurturing their animals and gathering around the hearth to share stories and laughter the beauty of the landscape was matched only by the warmth and kindness of the people who called it home life in the village was a harmonious blend of",
    "history is a tapestry of events people and places woven together to create the rich and diverse narrative of human civilization from the ancient civilizations of egypt and mesopotamia to the great empires of rome and china each chapter tells a story of triumphs struggles and lessons learned understanding our past provides valuable insights into our present and future helping us navigate the complexities of the modern world and shape ",
    "art has been a fundamental aspect of human culture for millennia reflecting the values beliefs and experiences of societies throughout history from the cave paintings of prehistoric times to the masterpieces of the renaissance and the avant garde movements of the 20th century art continues to inspire provoke and challenge us it serves as a mirror to our souls and a bridge to our shared humanity capturing the essence of the human experience "
  ];

  static String getRandomTargetText() {
    final random = Random();
    final shuffledTexts = List<String>.from(dummyTexts)..shuffle(random);
    return shuffledTexts.first;
  }
}