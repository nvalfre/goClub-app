import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/models/club_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';



class CardSwiper extends StatelessWidget {
  
  final List<ClubModel> clubs;
  
  CardSwiper({ @required this.clubs });

  
  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    return Container(
       padding: EdgeInsets.only(top: 10.0),
       child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context, int index){

            clubs[index].id = '${ clubs[index].id }-tarjeta';

            return Hero(
              tag: clubs[index].id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: ()=> Navigator.pushNamed(context, 'detalle', arguments: clubs[index]),
                  child: FadeInImage(
                    image: NetworkImage( clubs[index].logoUrl  ),
                    placeholder: AssetImage('assets/images/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )
              ),
            );
            
          },
          itemCount: clubs.length,
          // pagination: new SwiperPagination(),
          // control: new SwiperControl(),
      ),
    );

  }
}
