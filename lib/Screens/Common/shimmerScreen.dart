import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Constants/app_color.dart';

class ShimmerListViewForHome extends StatelessWidget {
  final int itemCount;
  ShimmerListViewForHome({required this.itemCount});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 300,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: AppColors.grey, width: 3),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 15.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 15.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 15.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 15.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 15.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 15.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: 15.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerListView extends StatelessWidget {
  final int itemCount;
  ShimmerListView({required this.itemCount});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: AppColors.grey, width: 0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 200,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerListViewForListofItems extends StatelessWidget {
  final int itemCount;
  ShimmerListViewForListofItems({required this.itemCount});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: AppColors.grey, width: 3),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  width: 100.0,
                  height: 350.0,
                  color: Colors.grey,
                ),
              ),
              title: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 10.0,
                          color: Colors.grey,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(""),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 10.0,
                        color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(""),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 10.0,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 10.0,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 10.0,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            height: 10.0,
                            color: Colors.grey,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(""),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            height: 10.0,
                            color: Colors.grey,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(""),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerListViewForYoutubeContent extends StatelessWidget {
  final int itemCount;
  const ShimmerListViewForYoutubeContent({required this.itemCount, super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: AppColors.grey, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 200,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
