// Create this file: lib/data/datasources/workout_data.dart

import '../../views/main_view/widgets/day_detail_sheet.dart';

class WorkoutData {
  // Get workout data for any day
  static List<WorkoutSet> getDayWorkout(int dayNumber) {
    // For now, return Day 1 data as example
    // You can expand this with a switch statement or map for different days
    return _getDay1Workout();
  }

  static List<WorkoutSet> _getDay1Workout() {
    return [
      WorkoutSet(
        setName: 'Set 1',
        exercises: [
          Exercise(name: 'Arm Circles', duration: 30, thumbnailPath: 'assets/images/exercises/arm_circles.png'),
          Exercise(name: 'Hip Circles', duration: 20, thumbnailPath: 'assets/images/exercises/hip_circles.png'),
          Exercise(name: 'Knee Circles', duration: 20, thumbnailPath: 'assets/images/exercises/knee_circles.png'),
          Exercise(name: 'Ankle Circles', duration: 20, thumbnailPath: 'assets/images/exercises/ankle_circles.png'),
          Exercise(name: 'Standing Leg Circles', duration: 20, thumbnailPath: 'assets/images/exercises/standing_leg_circles.png'),
        ],
      ),
      WorkoutSet(
        setName: 'Set 2',
        exercises: [
          Exercise(name: 'Beginner Jumping Jacks', duration: 30, thumbnailPath: 'assets/images/exercises/jumping_jacks.png'),
          Exercise(name: 'Side March', duration: 30, thumbnailPath: 'assets/images/exercises/side_march.png'),
          Exercise(name: 'Bent Over Twists', duration: 20, thumbnailPath: 'assets/images/exercises/bent_over_twists.png'),
          Exercise(name: 'March On The Spot Deep Breath', duration: 30, thumbnailPath: 'assets/images/exercises/march_spot.png'),
          Exercise(name: 'High Knee Jacks', duration: 30, thumbnailPath: 'assets/images/exercises/high_knee_jacks.png'),
          Exercise(name: 'Full Body Stretch', duration: 30, thumbnailPath: 'assets/images/exercises/full_body_stretch.png'),
        ],
      ),
      WorkoutSet(
        setName: 'Set 3',
        exercises: [
          Exercise(name: 'Wide Squat (Right)', duration: 30, thumbnailPath: 'assets/images/exercises/wide_squat_right.png'),
          Exercise(name: 'Wide Squat (Left)', duration: 30, thumbnailPath: 'assets/images/exercises/wide_squat_left.png'),
        ],
      ),
      WorkoutSet(
        setName: 'Set 4',
        exercises: [
          Exercise(name: 'Parcel Up & Down', duration: 30, thumbnailPath: 'assets/images/exercises/parcel_up_down.png'),
          Exercise(name: 'Cool Down Stretch', duration: 30, thumbnailPath: 'assets/images/exercises/cool_down.png'),
        ],
      ),
    ];
  }

  // You can add more days here
  static List<WorkoutSet> _getDay2Workout() {
    // Return different exercises for Day 2
    return [];
  }
}
