<svg-button>
        <button class="colins-submit">
            <svg width="196" height="70" 
                viewPort="0 0 196 70" version="1.1"
                xmlns="http://www.w3.org/2000/svg">
            
            <rect class="btn-shape btn-bg"
                    x="3" y="3" 
                    width="190" height="64"
                    rx="32" ry="32" 
                    fill="#ffffff"
                    fill-opacity="1"
                    stroke="#ccc" stroke-width="4"
                    />	
            <rect class="btn-shape btn-color"
                    x="3" y="3" 
                    width="190" height="64"
                    rx="32" ry="32" 
                    fill="#ffffff"
                    fill-opacity="0"
                    stroke="rgb(30,205,151)" stroke-width="4"
                    />
            <text class="checkNode" x="96" y="40" 
                    font-family="Montserrat" 
                    font-size="22"
                    fill-opacity="1"
                    text-anchor="middle"
                    fill="rgb(255,255,255)" >
                ✔
            </text>
            <text class="textNode" x="96" y="40" 
                    transform="scale(1)"
                    font-family="Montserrat" 
                    font-size="16"
                    fill-opacity="1"
                    text-anchor="middle"
                    fill="rgb(30,205,151)" >
                Submit
            </text>
            </svg>
        </button>

    <script>
        onMount() {
            $(function () {

                //Create variables we will be referencing in our tweens.
                var white = 'rgb(255,255,255)';
                var seafoam = 'rgb(30,205,151)';
                $buttonShapes = $('rect.btn-shape');
                $buttonColorShape = $('rect.btn-shape.btn-color');
                $buttonText = $('text.textNode');
                $buttonCheck = $('text.checkNode');

                //These are the button attributes which we will be tweening
                //This will be used with GSAP and the function below to tween
                var buttonProps = {
                    buttonWidth: $buttonShapes.attr('width'),
                    buttonX: $buttonShapes.attr('x'),
                    buttonY: $buttonShapes.attr('y'),
                    textScale: 1,
                    textX: $buttonText.attr('x'),
                    textY: $buttonText.attr('y')
                };

                //This is the update handler that lets us tween attributes
                function onUpdateHandler() {
                    $buttonShapes.attr('width', buttonProps.buttonWidth);
                    $buttonShapes.attr('x', buttonProps.buttonX);
                    $buttonShapes.attr('y', buttonProps.buttonY);
                    $buttonText.attr('transform', "scale(" + buttonProps.textScale + ")");
                    $buttonText.attr('x', buttonProps.textX);
                    $buttonText.attr('y', buttonProps.textY);
                }

                //Finally, create the timelines
                var hover_tl = new TimelineMax({
                    tweens: [
                        TweenMax.to($buttonText, .15, {
                            fill: white
                        }),
                        TweenMax.to($buttonShapes, .25, {
                            fill: seafoam
                        })
                    ]
                });
                hover_tl.stop();

                var tl = new TimelineMax({
                    onComplete: bind_mouseenter
                });
                //This is the initial transition, from [submit] to the circle
                tl.append(new TimelineMax({
                    align: "start",
                    tweens: [
                        TweenMax.to($buttonText, .15, {
                            fillOpacity: 0
                        }),
                        TweenMax.to(buttonProps, .25, {
                            buttonX: (190 - 64) / 2,
                            buttonWidth: 64,
                            onUpdate: onUpdateHandler
                        }),
                        TweenMax.to($buttonShapes, .25, {
                            fill: white
                        })
                    ],
                    onComplete: function () {
                        $buttonColorShape.css({
                            'strokeDasharray': 202,
                            'strokeDashoffset': 202
                        });
                    }
                }));

                //The loading dasharray offset animation… 
                tl.append(TweenMax.to($buttonColorShape, 1.2, {
                    strokeDashoffset: 0,
                    ease: Quad.easeIn,
                    onComplete: function () {
                        //Reset these values to their defaults.
                        $buttonColorShape.css({
                            'strokeDasharray': 453,
                            'strokeDashoffset': 0
                        });
                    }
                }));

                //The Finish - transition to check
                tl.append(new TimelineMax({
                    align: "start",
                    tweens: [
                        TweenMax.to($buttonShapes, .3, {
                            fill: seafoam
                        }),
                        TweenMax.to($buttonCheck, .15, {
                            fillOpacity: 1
                        }),
                        TweenMax.to(buttonProps, .25, {
                            buttonX: 3,
                            buttonWidth: 190,
                            onUpdate: onUpdateHandler
                        })
                    ]
                }));

                //The Reset - back to the beginning
                //For demo only - probably you would want to remove this.
                tl.append(TweenMax.to($buttonCheck, .1, {
                    delay: 1,
                    fillOpacity: 0
                }));

                tl.append(new TimelineMax({
                    align: "start",
                    tweens: [
                        TweenMax.to($buttonShapes, .3, {
                            fill: white
                        }),
                        TweenMax.to($buttonText, .3, {
                            fill: seafoam,
                            fillOpacity: 1
                        })
                    ],
                    onComplete: function () {
                        $('.colins-submit').removeClass('is-active');
                    }
                }));
                tl.stop();

                //-- On Click, we launch into the cool transition
                $('.colins-submit').on('click', function (e) {
                    //-- Add this class to indicate state
                    $(e.currentTarget).addClass('is-active');
                    tl.restart();
                    $('.colins-submit').off('mouseenter');
                    $('.colins-submit').off('mouseleave');
                });

                bind_mouseenter();

                function bind_mouseenter() {
                    $('.colins-submit').on('mouseenter', function (e) {
                        hover_tl.restart();
                        $('.colins-submit').off('mouseenter');
                        bind_mouseleave();
                    });
                }

                function bind_mouseleave() {
                    $('.colins-submit').on('mouseleave', function (e) {
                        hover_tl.reverse();
                        $('.colins-submit').off('mouseleave');
                        bind_mouseenter();
                    });
                }

            });
        }

        this.on('mount', this.onMount);
    </script>
</svg-button>