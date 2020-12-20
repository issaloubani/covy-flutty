import 'package:covid_tracker_app/global/notificaiton/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    context.bloc<NotificationBloc>().add(GetNotifications());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),

      body: BlocConsumer<NotificationBloc,NotificationState>(listener: (context, state) {

      },builder: (context, state) {
        if(state is NotificationLoaded){

          return ListView.builder(itemCount: state.notificationSnapshots.size,itemBuilder: (context, index) {
            var title = state.notificationSnapshots.docs[index].get('notification_title');
            var subtitle = state.notificationSnapshots.docs[index].get('notification_data');

            return ListTile(title: Text(title),subtitle:  Text(subtitle),leading: Icon(Icons.circle_notifications),);
          },);
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },),
    );
  }
}
