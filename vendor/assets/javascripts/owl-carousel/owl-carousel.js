var OwlCarousel = function () {

    return {

        //Owl Carousel
        initOwlCarousel: function () {


            //Owl Clients v1
            jQuery(".owl-clients-v1").owlCarousel({
                items : 7,
                autoPlay : 5000,
                itemsDesktop : [1000,5],
                itemsDesktopSmall : [900,4],
                itemsTablet: [600,3],
                itemsMobile : [300,2]
            });

    }

    };

}();
