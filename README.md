# FetchRecipes

### Summary

https://github.com/user-attachments/assets/ba2dcb97-ef23-4a83-87b4-68cce16c67c5

https://github.com/user-attachments/assets/1348869e-b8f9-4291-a453-0e0ca2160ca8

![simulator_screenshot_B4988121-0FEA-482B-9E31-2AC246574D08](https://github.com/user-attachments/assets/fc0e5693-c30b-4458-a35d-bbe232e0481f)

![simulator_screenshot_6ED48D76-3012-4B46-9F9B-6B8A6B867D23](https://github.com/user-attachments/assets/273bc9fc-4865-417f-95b9-849abe9c138d)

### Focus Areas
What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

The completion of this exercise was an opportunity to delight and show how my unique perspective can contribute to the team while also demonstrating my strengths as an engineer. Whenever I address a comprehensive technical problem, breaking it down into smaller pieces is the first task. With an api that fetches JSON data that powers the UI of the app, focusing on parsing the data efficiently and correctly (see String+Mobijake) is always the first step. After that, I wanted to make sure the data was delivered to the UI in a way that maximized the visible content to the user (LazyVGrid with two columns in portrait, three in landscape) and allowed for ease of scrolling to view additional items. Dark mode support was a must as well.

After locking in the initial UI, with a particular emphasis on accessibility, I zeroed in on the efficient network usage from the requirements. Creating a performant ImageCache that writes and reads from disk, but keeps an eye on not swelling the memory cache too large to affect device performance. 

Of course, unit testing is an absolute in mobile app engineering and I wanted to give a reasonable amount of code coverage for the scope of this project.

### Time Spent
Approximately how long did you spend working on this project? How did you allocate your time?

After receiving the assignment on Tuesday afternoon from Byron, I digested the requirements overnight and dug in on coding on Wednesday. I probably spent about 10-12 hours total between meetings at my job over the last few days.

### Trade-offs and Decisions
Did you make any significant trade-offs in your approach? Briefly explain any major decisions or compromises.

I probably could've provided a more robust filtering system in the recipes list (adding tabs for each cuisine, etc) but it felt insignificant to delivering clean code, adhering to best practices for accessibility, and ensuring good-enough test coverage.

Major decisions included:

- [x] MVVM architecture to promote SOLID principles (business-logic doesn't belong in the view layer, etc)
- [x] Testing - An integral part of every mobile app solution when the produced artifact lives on people's devices and you're beholden to the App and Play Store for updates
- [x] Ensuring all text received from the API was presented correctly to avoid Mojibake
- [x] Handling malformed and empty recipe data gracefully and not allowing a user to encounter a dead end
- [x] Taking advantage of all data points returned in the API (external and YouTube links) to deliverthe most functionality possible with the data provided

### Weakest Part of the Project
What do you think is the weakest part of your project? Where would you improve with more time?

- The weakest part of my project is probably the dumbed-down sorting without an ability to be more granular, as well as the lack of UI and integration tests. With more time, I would've liked to test out the functionality of the app on more devices.
- I didn't go down the path of adding much in the way of animations, but would have done so if I had more time.

### Additional Information
Is there anything else we should know? Feel free to share any insights, constraints, or interesting challenges you encountered.

- This was a fun exercise and the challenge presented by the Western European diacritics was a neat little curveball. Thanks for the opportunity!
