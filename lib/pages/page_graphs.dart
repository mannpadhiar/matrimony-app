import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:untitled/utils.dart';
import 'package:untitled/pages/ListPage.dart';

class Graphs extends StatefulWidget {
  const Graphs({super.key});

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  int maleCount = 0;
  int femaleCount = 0;
  double malePer = 0;
  double femalePer = 0;

  late Future<List<Map<String, dynamic>>> _futureData;

  Future<List<Map<String,dynamic>>> loadAsyncApiData() async{
    final data = await fetchDataFromApi();
    sortedUser = List.from(data);
    calculateGraph();
    return sortedUser;
  }

  void calculateGraph(){
    for(int i = 0;i<sortedUser.length;i++){
      if(sortedUser[i]['gender'] == 'Male'){
        maleCount = maleCount + 1;
      }else{
        femaleCount = femaleCount + 1;
      }
    }
    malePer = (maleCount*100/(maleCount + femaleCount));
    femalePer = 100.0 - malePer;
    print(malePer);
    print(femalePer);
    print(maleCount);
    print(femaleCount);
  }

  @override
  void initState() {
    super.initState();
    _futureData = loadAsyncApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analysis and Graphs',style: TextStyle(color: Colors.white),),backgroundColor: Theme.of(context).primaryColor,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(future: _futureData, builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: Color(0x32966AC9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Gender Distribution',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      SizedBox(height: 24),

                      AspectRatio(
                        aspectRatio: 1.5,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: malePer,
                                color: Colors.blue.shade400,
                                title: '${malePer.toStringAsFixed(1)}%',
                                radius: 80,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              PieChartSectionData(
                                value: femalePer,
                                color: Colors.pink.shade300,
                                title: '${femalePer.toStringAsFixed(1)}%',
                                radius: 80,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 0,
                            startDegreeOffset: 180,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(Colors.blue.shade400, 'Male'),
                          SizedBox(width: 32),
                          _buildLegendItem(Colors.pink.shade300, 'Female'),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Male: ',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '${femalePer.toStringAsFixed(1)}%'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),  // Explicit gap between the text elements
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Female: ',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '${femalePer.toStringAsFixed(1)}%'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Male Count: ',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '${maleCount}'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),  // Explicit gap between the text elements
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Female Count: ',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '${femaleCount}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },)
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}
