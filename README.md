# MovieQuiz  

MovieQuiz is an iOS application with quizzes about movies from the IMDb Top 250 and the most popular films according to IMDb.  

## 📝 App Description  
MovieQuiz is a single-page application where users test their knowledge of movie ratings. At the end of each game round, statistics are displayed, showing the number of correct answers and the user's best results. The goal of the game is to answer all 10 questions correctly.  

## 🎯 Main Features  
- Splash screen on app launch  
- Question screen with a movie image and two answer options: "Yes" and "No"  
- Answer validation with visual indication (border color change around the image)  
- Automatic transition to the next question after 1 second  
- Final alert with statistics after 10 questions  
- Statistics include:  
  - Number of correct answers  
  - Total number of quizzes played  
  - Best result (date and time)  
  - Average answer accuracy in percentage  
- Option to start a new round  
- Error handling for data loading with user notification and retry option  

## 📌 Tech Stack  
- Swift  
- UIKit  
- MVP  
- IMDb API  

## 🔧 Technical Details  
- Supports iPhone devices (iOS 15+)  
- Portrait mode only  
- Adapted for iPhone X and newer (no support for iPhone SE and iPad)  

## 🚀 Installation & Launch  
1. Clone the repository:  
   ```sh  
   git clone https://github.com/DanilOtmakhov/MovieQuiz.git  
   ```  
2. Open the project in Xcode.  
3. Run it on a simulator or a physical device.  

## 📌 Links  
- [Figma Design](https://www.figma.com/design/l0IMG3Eys35fUrbvArtwsR/YP-Quiz?node-id=367-593&p=f&t=k0itN9RWhs2Qx4RY-0)  
- [IMDb API](https://www.imdb.com/)  

