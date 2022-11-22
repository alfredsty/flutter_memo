import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> memoList = ['장보기 목록: 사과, 양파', '새메모']; // 전체 메모 목록

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("mymemo"),
      ),
      body: memoList.isEmpty
          ? Center(child: Text("메모를 작성해 주세요"))
          : ListView.builder(
              itemCount: memoList.length, // memoList 개수 만큼 보여주기
              itemBuilder: (context, index) {
                String memo = memoList[index]; // index에 해당하는 memo 가져오기
                return ListTile(
                  // 메모 고정 아이콘
                  leading: IconButton(
                    icon: Icon(CupertinoIcons.pin),
                    onPressed: () {
                      print('$memo : pin 클릭 됨');
                    },
                  ),
                  // 메모 내용 (최대 3줄까지만 보여주도록)
                  title: Text(
                    memo,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // 아이템 클릭시
                    print('$memo : 클릭 됨');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailPage(
                                index: index,
                                memoList: memoList,
                              )),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // + 버튼 클릭시 메모 생성 및 수정 페이지로 이동
          String memo = ''; // 빈 메모 내용 추가
          setState(() {
            memoList.add(memo);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(
                index: memoList.indexOf(memo),
                memoList: memoList,
              ),
            ),
          );
        },
      ),
    );
  }
}

// 메모 생성 및 수정 페이지
class DetailPage extends StatelessWidget {
  DetailPage({super.key, required this.memoList, required this.index});

  final List<String> memoList;
  final int index;

  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    contentController.text = memoList[index];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // 삭제 버튼 클릭시
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("정말로 삭제하시겠습니까?"),
                    actions: [
                      // 취소 버튼
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("취소"),
                      ),
                      // 확인 버튼
                      TextButton(
                        onPressed: () {
                          memoList.removeAt(index);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "확인",
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: contentController,
          decoration: InputDecoration(
            hintText: "메모를 입력하세요",
            border: InputBorder.none,
          ),
          autofocus: true,
          maxLines: null,
          expands: true,
          keyboardType: TextInputType.multiline,
          onChanged: (value) {
            // 텍스트필드 안의 값이 변할 때

            memoList[index] = value;
          },
        ),
      ),
    );
  }
}
