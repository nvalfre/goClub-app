import 'package:flutter_go_club_app/core/enums/viewstate.dart';
import 'package:flutter_go_club_app/core/models/comment.dart';
import 'package:flutter_go_club_app/core/services/api.dart';
import 'package:flutter_go_club_app/ui/config/locator.dart';

import 'base_model.dart';

class CommentsModel extends BaseModel {
  Api _api = locator<Api>();

  List<Comment> comments;

  Future fetchComments(int postId) async {
    setState(ViewState.Busy);
    comments = await _api.getCommentsForPost(postId);
    setState(ViewState.Idle);
  }
}
