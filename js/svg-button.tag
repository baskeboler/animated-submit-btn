<svg-button>
    <div class="svg-button">
        <button class="colins-submit">
                <svg ref="svgElement" riot-width="{width}" riot-height="{height}" 
                    viewPort="0 0 100% {height}" version="1.1"
                    xmlns="http://www.w3.org/2000/svg">
                
                <rect class="btn-shape btn-bg"
                        x="3" y="3" 
                        riot-width="{'95%'}" riot-height="{height2}"
                        rx="32" ry="32" 
                        fill="#ffffff"
                        fill-opacity="1"
                        stroke="#ccc" stroke-width="4"
                        />	
                <rect class="btn-shape btn-color"
                        x="3" y="3" 
                        riot-width="{'95%'}" riot-height="{height2}"
                        rx="32" ry="32" 
                        fill="#ffffff"
                        fill-opacity="0"
                        stroke="rgb(30,205,151)" stroke-width="4"
                        />
                <text class="checkNode" riot-x="{textX}" riot-y="{textY}" 
                        font-family="Montserrat" 
                        font-size="22"
                        fill-opacity="1"
                        text-anchor="middle"
                        fill="rgb(255,255,255)" >
                    ✔
                </text>
                <text class="textNode" riot-x="{textX}" riot-y="{textY}" 
                        transform="scale(1)"
                        font-family="Montserrat" 
                        font-size="16"
                        fill-opacity="1"
                        text-anchor="middle"
                        fill="rgb(30,205,151)" >
                    {opts.label}
                </text>
                </svg>
            </button>
    </div>

    <script>
        var tag = this;
        function calcWidth(){
            var chars = tag.opts.label.length || 10;
            var w = chars * 10 + 25;
            return w < 140 ? 140 : w;
        }
        onMount() {
            tag.width = opts.width || tag.refs.svgElement.style.width || calcWidth();
            tag.height = opts.height || 70;
            tag.height2 = tag.height - 6;
            tag.textX = tag.width / 2 - 4;
            tag.textY = tag.height / 2 + 5;
            tag.update();
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
                    buttonWidth: tag.width,//$buttonShapes.attr('width'),
                    buttonX: $buttonShapes.attr('x'),
                    buttonY: $buttonShapes.attr('y'),
                    textScale: 1,
                    textX: tag.textX, //$buttonText.attr('x'),
                    textY: tag.textY //$buttonText.attr('y')
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
                            buttonX: (tag.width * .95 - tag.height2) / 2,
                            buttonWidth: tag.width * .95 / 2,
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
                            'strokeDasharray': '400%',
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
                            buttonWidth: tag.width * .95,
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