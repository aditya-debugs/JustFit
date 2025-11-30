import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/discovery_widgets.dart';
import '../../../data/datasources/discovery_data.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Text(
                  'Discovery',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Body Specific Section
            SliverToBoxAdapter(
              child: BodySpecificSection(
                bodyParts: DiscoveryData.bodyParts,
              ),
            ),

            // Breast Cancer Awareness Month
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Breast Cancer Awareness Month',
                workouts: DiscoveryData.breastCancerMeta,
              ),
            ),

            // Knee Friendly Workouts
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Knee Friendly Workouts',
                workouts: DiscoveryData.kneeFriendlyMeta,
              ),
            ),

            // Bye Bye Belly
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Bye Bye Belly',
                workouts: DiscoveryData.byeByeBellyMeta,
              ),
            ),

            // Plus-Size Friendly Workouts
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Plus-Size Friendly Workouts',
                workouts: DiscoveryData.plusSizeMeta,
              ),
            ),

            // For a Healthier You
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'For a Healthier You',
                categoryLabel: 'FOR A HEALTHIER YOU',
                workouts: DiscoveryData.healthierYouMeta,
              ),
            ),

            // Strengthen and Stretch with Ease
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Strengthen and Stretch with Ease',
                categoryLabel: 'STRENGTHEN AND STRETCH WITH EASE',
                workouts: DiscoveryData.strengthenStretchMeta,
              ),
            ),

            // Easy Exercises You Can Do from Your Seat
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Easy Exercises You Can Do from Your Seat',
                categoryLabel: 'EASY EXERCISES YOU CAN DO FROM YOUR SEAT',
                workouts: DiscoveryData.seatExercisesMeta,
              ),
            ),

            // Revitalize and Renew
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Revitalize and Renew, Unleash Your Wellness!',
                categoryLabel: 'REVITALIZE AND RENEW, UNLEASH YOUR WELLNESS!',
                workouts: DiscoveryData.revitalizeMeta,
              ),
            ),

            // Release Pressure & Find Your Inner Calm
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'Release Pressure & Find Your Inner Calm',
                categoryLabel: 'RELEASE PRESSURE & FIND YOUR INNER CALM',
                workouts: DiscoveryData.innerCalmMeta,
              ),
            ),

            // Dance Party Time (Special Section)
            SliverToBoxAdapter(
              child: DancePartySection(
                title: 'Dance Party Time',
                sections: DiscoveryData.dancePartySections,
              ),
            ),

            // If You Can't Lose Weight, Try These
            SliverToBoxAdapter(
              child: WorkoutCategorySection(
                title: 'If You Can\'t Lose Weight, Try These',
                workouts: DiscoveryData.loseWeightMeta,
              ),
            ),

            // Bottom padding for navigation bar
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
