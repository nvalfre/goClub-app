import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/bloc/club_bloc.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_go_club_app/pages/search_delegate.dart';

import 'card_swiper_widget.dart';
import 'club_card_horizontal.dart';

class EmptyPage extends StatelessWidget {
  final clubBloc = new ClubsBloc();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
