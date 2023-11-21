# SeniorSignal

## Overview

### Description

SeniorSignal is an app designed to provide peace of mind to family and caregivers of elderly individuals. The app prompts the elderly user to verify their well-being at intervals chosen by their designated contacts. If there's no response within a certain timeframe, an alert is sent to the contact, ensuring timely checks and assistance if needed.

Video Link: https://youtube.com/shorts/beGKLf9zyEc

### App Evaluation

- **Category:** Healthcare
- **Mobile:** iOS
- **Story:** SeniorSignal was conceptualized to bridge the communication gap between elderly individuals and their caregivers or relatives. 
- **Market:** Individuals who have elderly family members.
- **Habit:** The app encourages daily or even multiple check-ins, fostering a habit of regular interaction.
- **Scope:**  SeniorSignal aims to offer fundamental check-in functionalities. But the scope can expand to integrate features like emergency services, integration with smart home devices, health monitoring (e.g., linking to wearables for heart rate or fall detection), and even social features that allow seniors to connect with their peers. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User (caregiver/relative) can set up an account.
- [x] Senior can create and configure their own profile.
- [x] Caregiver/relative can add a senior’s profile to their monitoring list.
- [x] Caregiver/relative can initiate a check-in anytime.
- [x] Senior receives a notification prompting them to indicate their status ("Yes, I'm okay" or "No, I'm not okay, I need help").
- [x] Caregiver/relative receives immediate feedback/notification about senior’s response.
- [x] System can send automatic check-ins based on a predefined schedule set by the caregiver/relative.
- [x] Senior can manually send a "need help" signal even without a prompt.
- [x] Caregiver/relative can view check-in history.

**Optional Nice-to-have Stories**

* Senior's profile can include essential emergency contact details and medical information.
* Multiple caregivers/relatives can monitor the same senior.
* Caregiver/relative can customize the check-in message.
* System sends a reminder to the senior if they don't respond within a certain time frame.
* Caregiver/relative can adjust the notification sound/vibration to ensure it’s noticeable for seniors.
* System can integrate with smart home devices (like wearable emergency buttons).
* Senior can add a quick voice note or text note to their check-in response.
* Advanced analytics to track and highlight any changes in senior’s activity/response pattern.
* Caregiver/relative can set up geofencing notifications if the senior leaves a certain area.
* A built-in community feature for caregivers/relatives to share tips and advice.

### 2. Screen Archetypes

**Login Screen**

* User can login.

**Registration Screen**

* User (caregiver/relative) can set up an account.
* Senior can create and configure their own profile.

**Dashboard/Stream**

* Caregiver/relative can view a list of seniors they're monitoring.
* Caregiver/relative receives immediate feedback/notification about senior’s response.
* Caregiver/relative can view check-in history for each senior.

**Check-In Screen**

* Caregiver/relative can initiate a check-in anytime.
* Senior receives a notification and can respond with their status ("Yes, I'm okay" or "No, I'm not okay, I need help").

**Profile Configuration**

* Caregiver/relative can add or edit a senior’s profile on their monitoring list.
* Senior can manually send a "need help" signal.

**Automatic Check-In Setup**

* Caregiver/relative can set the system to send automatic check-ins based on a predefined schedule.

**Search and Add Senior**

* Caregiver/relative can search for seniors by their name or unique identifier.
* Caregiver/relative can add a senior’s profile to their monitoring list.

**Emergency Information**

* Senior's profile displays essential emergency contact details and medical information.

### 3. Navigation

**Tab Navigation (Tab to Screen)**

* Dashboard/Stream - Main screen where a caregiver/relative can view the list of seniors they're monitoring and their latest responses.
* Check-In - Screen to initiate a manual check-in.
* Search and Add Senior - Locate and add seniors to the monitoring list.
* Profile Configuration - Add or adjust the details of seniors being monitored.


**Flow Navigation (Screen to Screen)**

* Login Screen
=> Dashboard
* Registration Screen
=> Dashboard

* Dashboard
=> Profile Configuration (when clicking on a specific senior's name or details)
=> Check-In (for a specific senior or if there's a prompt to check-in)

* Check-In Screen
=> Dashboard (after receiving a response or after sending a check-in)

* Profile Configuration
=> Dashboard (after saving or making changes)

* Automatic Check-In Setup 
=> Dashboard (after setting the schedule)

* Search and Add Senior
=> Profile Configuration (after selecting a senior to add)

* Emergency Information 
=> Profile Configuration (to edit or view more details)

## Wireframes

### [BONUS] Digital Wireframes & Mockups

https://www.figma.com/file/NtwgN74IbcYnvAJGXu4IT2/Uhhhhhh?type=design&node-id=0%3A1&mode=design&t=4XnJzKI5z8AVlTN3-1
