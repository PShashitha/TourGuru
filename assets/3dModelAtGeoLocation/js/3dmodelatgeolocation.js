var World = {

    init: function initFn() {
        this.createModelAtLocation();
    },

    createModelAtLocation: function createModelAtLocationFn() {

        /*
            First a location where the model should be displayed will be defined. This location will be relativ to
            the user.
        */
        var location = new AR.GeoLocation(6.9158110, 79.977774, 100);

        /* Next the model object is loaded. */
        var modelEarth = new AR.Model("assets/earth.wt3", {
            onLoaded: this.worldLoaded,
            onError: World.onError,
            scale: {
                x: 10,
                y: 10,
                z: 10
            },
            rotate: {
                x: 0,
                y: -1
            }

        });

        var indicatorImage = new AR.ImageResource("assets/indi.png", {
            onError: World.onError
        });

        var indicatorDrawable = new AR.ImageDrawable(indicatorImage, 0.1, {
            verticalAnchor: AR.CONST.VERTICAL_ANCHOR.TOP
        });

        /* Putting it all together the location and 3D model is added to an AR.GeoObject. */
        this.geoObject = new AR.GeoObject(location, {
            drawables: {
                cam: [modelEarth],
                indicator: [indicatorDrawable]
            }
        });
    },

    onError: function onErrorFn(error) {
        alert(error);
    },

    worldLoaded: function worldLoadedFn() {
        document.getElementById("loadingMessage").style.display = "none";
    }
};

World.init();