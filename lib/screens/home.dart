import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<VideosBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: Image.asset("images/yt_logo_rgb_dark.png"),
          alignment: Alignment.topLeft,
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.of<FavoriteBloc>(context).outFav,
              initialData: {},
              builder: (context, snapshot){
                if(snapshot.hasData) return Text("${snapshot.data.length}");
                else return Container();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result = await showSearch(context: context, delegate: DataSearch());
              if ( result != null ) bloc.inSearch.add(result);

            },
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
        stream: bloc.outVideos,
        initialData: [],
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemBuilder: (context, index){
                  if(index < snapshot.data.length){
                    return VideoTile(snapshot.data[index]);
                  } else if(index > 1){
                    bloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),),
                    );
                  } else {
                    return Container();
                  }
                },
              itemCount: snapshot.data.length + 1,
            );
          } else
              return Container();

        },
      ),
    );
  }
}
