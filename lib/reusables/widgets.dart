import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartshop/models/category.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/ui/product_page.dart';

class CategoryWidget extends StatefulWidget {
  final Categories category;

  const CategoryWidget({super.key, required this.category});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicWidth(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[200]!,
                  width: 2,
                ),
                shape: BoxShape.rectangle,
              ),
              child: ListTile(
                leading: Image.network(
                  widget.category.image,
                  height: 25,
                  width: 25,
                ),
                title: Text(widget.category.name),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class ProductCards extends StatelessWidget {
  const ProductCards({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ProductPage(product: product);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const curve = Curves.easeIn;
              final curvedAnimation =
                  CurvedAnimation(parent: animation, curve: curve);

              return ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(curvedAnimation),
                child: child,
              );
            },
            transitionDuration:
                const Duration(milliseconds: 600), // Slow down the animation
          ),
        );
      },
      child: SizedBox(
        height: 200,
        width: 160,
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 75.0, top: 5.0),
                child: Icon(Icons.favorite_outline_outlined,
                    color: Colors.red, size: 30),
              ),
              const SizedBox(height: 5),
              AspectRatio(
                aspectRatio: 1.6,
                child: Image.network(
                  product.image,
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: RefreshProgressIndicator(
                      elevation: 5,
                      indicatorMargin: EdgeInsetsGeometry.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyDeals extends StatefulWidget {
  final List<Product> deals;

  const DailyDeals({super.key, required this.deals});

  @override
  _DailyDealsState createState() => _DailyDealsState();
}

class _DailyDealsState extends State<DailyDeals> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Set up a timer to automatically change the deal
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.deals.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity, // Take up the full width of the screen
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.deals.length,
        itemBuilder: (context, index) {
          final deal = widget.deals[index];
          return _buildDealCard(deal);
        },
      ),
    );
  }

  Widget _buildDealCard(Product deal) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deal.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      "${deal.description.substring(0, 100)} + .",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    //show the discount price in an elevated button
                    child: Text(
                      '${deal.discount} % OFF',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - (175),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(3, 3),
                          blurRadius: 5)
                    ],
                    image: DecorationImage(
                      image: NetworkImage(deal.image),
                      fit: BoxFit.cover,
                      invertColors: false,
                    ),
                  ),
                ),

                // Image.network(
                //   deal.image,
                //   height: 180,
                //   width: MediaQuery.of(context).size.width,
                //   fit: BoxFit.fill,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Deal {
  final String name;
  final String description;
  final String image;

  Deal({required this.name, required this.description, required this.image});
}

//create a list of products that will be added to the database
//The categories are men,women,unisex.

final List<Product> database_products = [
  Product(
    id: 1,
    name: 'Jacket',
    category: 'Men',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/340/3407061210393220362/jpeg-600/G03.jpg',
    price: 10.99,
    discount: 2,
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Brace for the elements in style with our premium men's jacket.

Durable, water-resistant fabric to keep you dry
Insulated lining for warmth without bulk
Adjustable hood and cuffs for a customized fit
Sleek, modern design for a polished look
This jacket is the ultimate fusion of function and fashion. Crafted from high-quality, weather-resistant materials, it shields you from the elements while elevating your everyday style. Whether you're commuting to work or exploring the great outdoors, this versatile jacket has you covered.

It's the perfect piece for the man who demands performance and sophistication. Slip it on and take on the day with confidence, knowing you look and feel your best.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 2,
    name: 'White Shirt',
    category: 'Men',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/231/2313358342610752832/jpeg-600/G03.jpg',
    price: 12.50,
    discount: 3.5,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Dare to stand out in our bold, attention-grabbing red shirt. This vibrant essential is the perfect way to inject some personality into your wardrobe.

Made from premium, lightweight cotton for all-day comfort
Tailored silhouette creates a flattering, streamlined look
Wrinkle-resistant fabric keeps you looking sharp
Available in a range of sizes to flatter every frame
Whether you're heading to the office or a night out with friends, this red shirt is sure to make an impression. Wear it solo with dark-wash jeans and leather boots for a modern, edgy look. Or layer it under a navy blazer and pair with chinos for a polished, put-together ensemble. Wherever life takes you, this versatile red shirt will help you command attention.

""",
    rating: 4.0,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 3,
    name: 'Blue Shirt',
    category: 'Women',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/318/3181442159106594345/jpeg-600/G03.jpg',
    price: 13.00,
    discount: 4.0,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
The perfect blue shirt to elevate your style.

100% premium cotton for ultimate comfort
Tailored fit flatters your frame
Wrinkle-resistant for all-day wear
Available in a range of rich, versatile shades
This blue shirt is the ultimate wardrobe staple. Crafted from soft, breathable cotton, it delivers unparalleled comfort all day long. The tailored fit flatters your physique, while the wrinkle-resistant fabric keeps you looking sharp from morning to night. Whether you're dressing up for the office or keeping it casual on the weekend, this versatile blue shirt is a must-have.

This blue shirt is perfect for the modern man who values quality and style. Pair it with chinos for a polished, put-together look, or throw it on with your favorite jeans for an effortlessly cool vibe. Either way, you'll exude confidence and sophistication wherever you go.
""",
    rating: 4.0,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 4,
    name: 'Black Pants',
    category: 'Men',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/318/3181442159106594345/jpeg-600/G03.jpg',
    price: 15,
    discount: 0,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Experience ultimate comfort and style with these versatile Black Pants, a must-have addition to your wardrobe. Crafted with high-quality materials, these pants offer a perfect blend of durability and sophistication. Whether you're dressing up for a formal occasion or keeping it casual for everyday wear, these Black Pants are designed to elevate your look effortlessly. Featuring a timeless black color that pairs seamlessly with any outfit, these pants are a versatile choice for any fashion-savvy individual. The sleek design and tailored fit provide a flattering silhouette, while the stretchy fabric ensures freedom of movement and all-day comfort. Stand out from the crowd with these Black Pants that exude elegance and class, making them an essential piece for every fashion-forward individual's collection. Upgrade your wardrobe with these Black Pants and experience the perfect combination of style, comfort, and flexibility.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 5,
    name: 'Red summer dress',
    category: 'Women',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/318/3181442159106594345/jpeg-600/G03.jpg',
    price: 25.00,
    discount: 7.5,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Elevate your summer style with our chic Blue Summer Dress, a must-have piece for the modern woman. Crafted with attention to detail and quality, this dress is the epitome of elegance and comfort for women who appreciate both style and functionality in their wardrobe. With a flattering silhouette and a vibrant blue hue, this dress is perfect for any occasion, from casual outings to special events.

Designed to accentuate the feminine figure, the Blue Summer Dress features a timeless design that exudes sophistication and effortless charm. The soft and breathable fabric ensures all-day comfort, while the sleeveless design and knee-length cut add a touch of versatility to your ensemble. Whether you're attending a weekend brunch or a summer soirée, this dress will effortlessly take you from day to night with grace and poise.

Embrace the essence of summer with this versatile piece that can be dressed up with heels and statement accessories or dressed down with sandals and a straw hat. The Blue Summer Dress is a versatile addition to your wardrobe that will become a staple for warm-weather days and beyond. Elevate your style game with this timeless piece that combines fashion-forward design with everyday wearability. Experience the perfect blend of style and comfort with our Blue Summer Dress.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 6,
    name: 'Blue Suit',
    category: 'Women',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/338/3383167878768366603/jpeg-600/G03.jpg',
    price: 100.50,
    discount: 0.0,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Elevate your professional wardrobe with our stunning Blue Suit designed for women. Crafted with the finest materials and tailored to perfection, this suit exudes sophistication and style. Whether you're heading to a business meeting or a formal event, this suit is sure to make a lasting impression. The versatile shade of blue adds a modern touch to your look, while the impeccable fit ensures all-day comfort and confidence. Make a statement with this timeless piece that effortlessly combines elegance and professionalism. Upgrade your ensemble with the Blue Suit and step out in style.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 7,
    name: 'Hoody',
    category: 'Unisex',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/325/3250173346540688913/jpeg-600/G03.jpg',
    price: 23.0,
    discount: 0.0,
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Step up your style game with our versatile unisex Hoody, designed to keep you looking effortlessly cool and comfortable all day long. Crafted with premium materials, this Hoody is a must-have addition to your wardrobe for any season. Whether you're lounging at home or heading out for a casual outing, the Hoody provides the perfect blend of cozy warmth and on-trend fashion. The classic design ensures a timeless appeal, while the high-quality construction promises durability for long-lasting wear. Elevate your everyday look with the Hoody that effortlessly combines style and comfort. Grab yours now and experience the ultimate in laid-back luxury.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 8,
    name: 'Jumper',
    category: 'Unisex',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/340/3407061210393220362/jpeg-600/G03.jpg',
    price: 17.5,
    discount: 1.2,
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Elevate your style and comfort with our versatile unisex jumper, designed to meet the needs of the modern individual. Crafted with meticulous attention to detail and quality, this jumper offers a perfect blend of fashion and functionality. Whether you're heading out for a casual gathering or lounging at home, this jumper is the perfect choice for any occasion. The unisex design ensures a universal fit and appeal, making it a must-have addition to your wardrobe. Made with premium materials, this jumper is not only stylish but also durable for long-lasting wear. Stay effortlessly chic and cozy with our unisex jumper, a timeless piece that transcends trends and seasons. Add this essential staple to your collection today and experience the perfect harmony of style and comfort.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 9,
    name: 'Shorts',
    category: 'Men',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3075578014755460813/jpeg-600/G03.jpg',
    price: 10.0,
    discount: 0.0,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color.fromARGB(255, 22, 2, 196),
      const Color(0xffd32f2f),
      const Color.fromARGB(255, 86, 104, 36),
    ],
    description: """
Elevate your style game with these versatile men's shorts that seamlessly transition from office wear to casual outings. Crafted to perfection, these shorts are the epitome of sophisticated comfort, making them a must-have addition to your wardrobe. Whether you're heading to a business meeting or relaxing with friends, these shorts effortlessly blend style and functionality. Designed to offer the perfect fit and unmatched comfort, they are the ideal choice for the modern man on the go. With a focus on quality and style, these shorts are the perfect blend of formal and casual, catering to all your fashion needs. Embrace the versatility and charm of these men's shorts, and make a fashion statement wherever you go. Choose style. Choose comfort. Choose these shorts.
""",
    rating: 4.0,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 10,
    name: 'Loafers',
    category: 'Shoes',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/246/2469697482188133857/jpeg-600/G03.jpg',
    price: 49.99,
    discount: 2.5,
    sizes: ['7', '8', '9', '10'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color.fromARGB(255, 0, 6, 8),
      const Color(0xffd32f2f),
      const Color.fromARGB(255, 129, 143, 2),
    ],
    description: """
Elevate your formal attire with these sophisticated Men's Official Loafers. Crafted with precision and style in mind, these loafers are the perfect blend of elegance and comfort. Step into any boardroom or event with confidence as these shoes exude a timeless charm that is sure to make a statement. The high-quality materials used ensure durability and long-lasting wear, while the meticulous attention to detail in the design guarantees a polished finish. Whether you're at a meeting or a special occasion, these loafers will be the perfect companion to your professional ensemble. Update your footwear collection with these classic loafers and experience style and sophistication like never before.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 11,
    name: 'Sneakers',
    category: 'Shoes',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3074989205164660312/jpeg-600/G03.jpg',
    price: 59.00,
    discount: 0.0,
    sizes: ['7', '8', '9', '10'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Step up your shoe game with these sleek men's official sneakers. Crafted with precision and style in mind, these shoes are the perfect blend of comfort and sophistication. Whether you're headed to the office or out for a casual weekend stroll, these sneakers will keep you looking sharp and feeling great. The durable construction ensures long-lasting wear, while the modern design adds a touch of flair to any outfit. Don't settle for ordinary footwear - elevate your style with these versatile sneakers that are sure to become your new go-to option. Order yours today and experience the ultimate combination of style and comfort!
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 12,
    name: 'Safari Boots',
    category: 'Shoes',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/167/1671161248747623846/jpeg-600/G05.jpg',
    price: 43.50,
    discount: 1.5,
    sizes: ['7', '8', '9', '10'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color.fromARGB(255, 213, 235, 152),
      const Color.fromARGB(255, 71, 1, 233),
      const Color(0xffc2185b),
    ],
    description: """
Step into the wild with our versatile safari boots, designed to keep you stylish and comfortable on all your adventures. Crafted for both men and women, these unisex shoes are the perfect blend of functionality and fashion. Whether you're trekking through the rugged terrain or simply exploring the urban jungle, these safari boots will provide the support and durability you need. With a focus on quality materials and superior craftsmanship, these boots are built to withstand the test of time. The rugged yet refined design ensures that you can seamlessly transition from outdoor excursions to city streets without missing a beat. Equip yourself with the ultimate footwear companion for your next expedition and experience the perfect balance of style and performance with our safari boots.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 13,
    name: 'Vest InnerWear',
    category: 'Men',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/329/3292313046533281111/jpeg-600/G03.jpg',
    price: 4.50,
    discount: 0.0,
    sizes: ['S', 'M', 'L', 'XL'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description: """
Enhance your everyday comfort with the Vest InnerWear for men. Crafted with premium materials and expert design, this innerwear is a must-have addition to your wardrobe. Whether you're working, exercising, or simply relaxing at home, this vest provides the perfect blend of support and breathability. The seamless construction ensures a smooth fit that is ideal for layering under any outfit. The moisture-wicking fabric keeps you cool and dry throughout the day, while the snug yet flexible design moves with your body for unrestricted movement. Say goodbye to uncomfortable undergarments and elevate your daily wear with the Vest InnerWear. Upgrade to a new standard of comfort and style today.
""",
    rating: 4.5,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 14,
    name: 'White Shirt',
    category: 'Men',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/231/2313358342610752832/jpeg-600/G03.jpg',
    price: 23.2,
    discount: 9.6,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description:
        'Stay sharp and stylish with our classic white shirt. Made from premium cotton, this shirt is perfect for any occasion. Whether you\'re dressing up for a formal event or keeping it casual, this versatile piece will keep you looking your best. The tailored fit and crisp white color make it a timeless addition to your wardrobe. Pair it with jeans for a laid-back look or dress it up with a blazer for a more polished ensemble. Wherever you go, this white shirt will keep you looking sharp and sophisticated.',
    rating: 4.0,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 15,
    name: 'Skirt',
    category: 'Women',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3072129647899579889/jpeg-600/G03.jpg',
    price: 37.98,
    discount: 0.5,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description:
        'Add a touch of elegance to your wardrobe with our stylish skirt. Made from high-quality fabric, this skirt is perfect for any occasion. Whether you\'re heading to the office or out for a night on the town, this versatile piece will keep you looking chic and sophisticated. The flattering silhouette and classic design make it a timeless addition to your collection. Pair it with a blouse for a polished look or a t-shirt for a more casual vibe. Wherever you go, this skirt will keep you looking fabulous.',
    rating: 4.0,
    isLiked: false,
    isSelected: false,
  ),
  Product(
    id: 16,
    name: 'Black & Red Checked Dress',
    category: 'Women',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/322/3221259227112674598/jpeg-600/G03.jpg',
    price: 76.93,
    discount: 5.3,
    sizes: ['S', 'M', 'L'],
    colors: [
      const Color(0xFFFFFFFF),
      const Color(0xffe0e0e0),
      const Color(0xff455a64),
      const Color(0xffd32f2f),
      const Color(0xffc2185b),
    ],
    description:
        'Make a statement with our stunning black dress. Crafted from luxurious fabric, this dress is perfect for any special occasion. Whether you\'re attending a wedding or a cocktail party, this elegant piece will keep you looking glamorous and chic. The timeless design and flattering fit make it a must-have addition to your wardrobe. Pair it with heels and statement jewelry for a show-stopping look. Wherever you go, this black dress will turn heads and make you feel like a million bucks.',
    rating: 4.0,
    isLiked: false,
    isSelected: false,
  ),
];

//Categories for the products
final List<Categories> categories = [
  Categories(
    id: 1,
    name: 'Men Wear',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3074989205164660312/jpeg-600/G03.jpg',
    isSelected: false,
  ),
  Categories(
    id: 1,
    name: 'Women Wear',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3074989205164660312/jpeg-600/G03.jpg',
    isSelected: false,
  ),
  Categories(
    id: 1,
    name: 'FootWear',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3074989205164660312/jpeg-600/G03.jpg',
    isSelected: false,
  ),
  Categories(
    id: 1,
    name: 'Belts',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3074989205164660312/jpeg-600/G03.jpg',
    isSelected: false,
  ),
  Categories(
    id: 1,
    name: 'Head Wear',
    image:
        'https://www.shutterstock.com/pixelsquid/assets_v2/307/3074989205164660312/jpeg-600/G03.jpg',
    isSelected: false,
  ),
];
