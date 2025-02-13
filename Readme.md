# FetchRecipe App (Take Home Assignment)

## Tech Stack:
- **Frontend**: SwiftUI, Lottie (Graphic Animation), Adobe (Logo)
- **Backend**: Swift, Gemini API
- **Development**: XCode, Git, AppStoreConnect

## App Store: [https://apps.apple.com/app/id6741867800](https://apps.apple.com/app/id6741867800)

## iOS Snippets
<div style="display: flex; justify-content: space-around;">
  <div style="text-align: center; width: 30%; margin-right: 10px;">
    <p><strong>Search and Filter</strong></p>
    <img src="ReadmeImages/search.gif" alt="Search and Filter" />
  </div>
  
  <div style="text-align: center; width: 30%; margin-right: 10px;">
    <p><strong>Recipe Detail View</strong></p>
    <img src="ReadmeImages/detail.gif" alt="Recipe Detail View" />
  </div>
  
  <div style="text-align: center; width: 30%;">
    <p><strong>Recipe AI View</strong></p>
    <img src="ReadmeImages/ai.gif" alt="Recipe AI View" />
  </div>
</div>


## iPad Screenshots
<div style="display: flex; justify-content: space-around;">
  <img src="ReadmeImages/iPad/5.png" alt="Search and Filter" width="30%" style="margin-right: 10px;" />
  <img src="ReadmeImages/iPad/6.png" " alt="Recipe Detail View" width="30%" style="margin-right: 10px;" />
  <img src="ReadmeImages/iPad/3.png"  alt="Recipe AI View" width="30%" />
</div>


## watchOS Screenshots (Very Basic)
<div style="display: flex; justify-content: space-around;">
  <img src="ReadmeImages/watchOS/1.png" alt="Search and Filter" width="30%" style="margin-right: 10px;" />
  <img src="ReadmeImages/watchOS/2.png" " alt="Recipe Detail View" width="30%" style="margin-right: 10px;" />
  <img src="ReadmeImages/watchOS/3.png"  alt="Recipe AI View" width="30%" />
</div>

## MacOS Screenshots


## Handoff Screenshot



## Unique Features:
1. **Gemini API Integration**: Provides contextual information to users, enabling them to query any recipe-related information.
2. **Multi-Platform Support**: Developed for **iOS**, **iPadOS**, **watchOS**, and **MacOS**.
3. **Sharing Functionality**: Allows users to easily share recipes with friends.
4. **Handoff Support**: Seamless device transitions between Apple ecosystem devices.
5. **Search & Filter**: Efficient search and filter functionality to help users find the perfect recipe.


## Setup Instructions:
1. **Clone the repository****
   ```
   git clone https://github.com/nuttysunday/Fetch-Recipe-iOS-app
   ```
2. **Install Lottie SPM:**
    ```
   Open your Xcode project.
   Go to File -> Swift Packages -> Add Package Dependency.
   Enter the Lottie GitHub repository URL:  https://github.com/airbnb/lottie-spm
   ```




## Future Plans:
1. **Chat Format**: Store query data in a **chat format** for improved interaction.
2. **Internal Framework**: Build an internal framework for shared codebases across platforms.
3. **UI Optimization**: Tailor the UI for each platform to ensure a consistent user experience.
4. **CI/CD Pipeline**: Set up a Xcloud CI/CD pipeline to deploy the app automatically to TestFlight after code is pushed to the main branch for beta testing.