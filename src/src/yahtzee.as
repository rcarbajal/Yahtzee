import flash.events.Event;
import flash.system.System;
import mx.core.SoundAsset;

private const CRITICAL_SCALE:Number = 0.1;

private const YAHTZEE:Number = 1;
private const FULL_H0USE:Number = 2;
private const THREE_OF_A_KIND:Number = 3;
private const FOUR_OF_A_KIND:Number = 4;
private const SMALL_STRAIGHT:Number = 5;
private const LARGE_STRAIGHT:Number = 6;

private var currRollCount:Number = 0;
private var isGameOver:Boolean = true;
private var roundCount:Number = 0;
private var hasScoredThisRound:Boolean = false;

private var dieCheckboxes:Array = new Array();
private var dieLabels:Array = new Array();
private var dieNums:Object = { 1:0, 2:0, 3:0, 4:0, 5:0, 6:0 };

private var particle:Particle = null;
private var particles:Array = new Array();
private var scaleMaxIdx:Number = 0;
private var scaleMax:Number = 0;
private var pIdx:Number = 0;
private var boomParticleCount:Number = 0;
private var fwCount:Number = 0;

[Embed(source='../media/explosion.mp3')]
private var ExplosionSound:Class;
private var explosion:SoundAsset = new ExplosionSound() as SoundAsset;

[Embed(source='../media/fwlaunch.mp3')]
private var LaunchSound:Class;
private var launch:SoundAsset = new LaunchSound() as SoundAsset;



/********************
 * PUBLIC FUNCTIONS *
 ********************/

public function init():void {
	//create die arrays
	dieCheckboxes = [chkDie1, chkDie2, chkDie3, chkDie4, chkDie5]; //five dice checkboxes
	dieLabels = [lblDie1, lblDie2, lblDie3, lblDie4, lblDie5]; //five dice value textboxes
	
	//disable all buttons until new game is started
	isGameOver = true;
	btn1.enabled = false;
	btn2.enabled = false;
	btn3.enabled = false;
	btn4.enabled = false;
	btn5.enabled = false;
	btn6.enabled = false;
	btn3Kind.enabled = false;
	btn4Kind.enabled = false;
	btnFull.enabled = false;
	btnSm.enabled = false;
	btnLg.enabled = false;
	btnYahtzee.enabled = false;
	btnChance.enabled = false;
	btnRoll.enabled = false;
	for each(var chk:CheckBox in dieCheckboxes)
		chk.enabled = false;
} //end function init

public function resetGame():void {
	currRollCount = 0;
	roundCount = 0;
	hasScoredThisRound = false;
	isGameOver = false;
	btn1.enabled = true;
	btn2.enabled = true;
	btn3.enabled = true;
	btn4.enabled = true;
	btn5.enabled = true;
	btn6.enabled = true;
	btn3Kind.enabled = true;
	btn4Kind.enabled = true;
	btnFull.enabled = true;
	btnSm.enabled = true;
	btnLg.enabled = true;
	btnYahtzee.enabled = true;
	btnChance.enabled = true;
	btnRoll.enabled = true;
	for each(var chk:CheckBox in dieCheckboxes) {
		chk.selected = false;
		chk.enabled = true;
	} //end for
	lbl1.text = "";
	lbl2.text = "";
	lbl3.text = "";
	lbl4.text = "";
	lbl5.text = "";
	lbl6.text = "";
	lblScored.text = "0";
	lblBonus.text = "0";
	lblUpper.text = "0";
	lbl3Kind.text = "";
	lbl4Kind.text = "";
	lblFullHouse.text = "";
	lblSm.text = "";
	lblLg.text = "";
	lblYahtzee.text = "";
	lblChance.text = "";
	lblLower.text = "0";
	lblBonusYahtzee.text = "0";
	lblGameTotal.text = "0";
	for each(var lbl:Label in dieLabels)
		lbl.text = "";
	lblGameOver.visible = false;
} //end function resetGame

public function roll():void {
	hasScoredThisRound = false;
	
	if(currRollCount < 3) {
		for (var i:Number = 0; i < dieCheckboxes.length;  ++i) {
			if (!dieCheckboxes[i].selected)
				dieLabels[i].text = getRandomNumber().toString();
		} //end for
		
		//start fireworks if necessary
		resetDieNums();
		//count each number's occurrence
		for each(var lbl:Label in dieLabels)
			++dieNums[parseInt(lbl.text, 10)];
		for (var j:Number = 1; j <= 6; ++j) {
			if (dieNums[j] == 5) {
				doFireworks();
				break;
			} //end if
		} //end for
		
		++currRollCount;
		btnRoll.enabled = currRollCount < 3;
	} //end if
	else btnRoll.enabled = false;
} //end function roll

public function score(cat:String):void {
	if(!hasScoredThisRound) {
		switch(cat) {
			case "1":
				lbl1.text = scoreUpper(1);
				btn1.enabled = false;
				break;
			case "2":
				lbl2.text = scoreUpper(2);
				btn2.enabled = false;
				break;
			case "3":
				lbl3.text = scoreUpper(3);
				btn3.enabled = false;
				break;
			case "4":
				lbl4.text = scoreUpper(4);
				btn4.enabled = false;
				break;
			case "5":
				lbl5.text = scoreUpper(5);
				btn5.enabled = false;
				break;
			case "6":
				lbl6.text = scoreUpper(6);
				btn6.enabled = false;
				break;
			case "3kind":
				lbl3Kind.text = scoreOfKinds(THREE_OF_A_KIND);
				btn3Kind.enabled = false;
				break;
			case "4kind":
				lbl4Kind.text = scoreOfKinds(FOUR_OF_A_KIND);
				btn4Kind.enabled = false;
				break;
			case "full":
				lblFullHouse.text = scoreFHorY(FULL_H0USE);
				btnFull.enabled = false;
				break;
			case "smstr8":
				lblSm.text = scoreStraights(SMALL_STRAIGHT);
				btnSm.enabled = false;
				break;
			case "lgstr8":
				lblLg.text = scoreStraights(LARGE_STRAIGHT);
				btnLg.enabled = false;
				break;
			case "yahtzee":
				lblYahtzee.text = scoreFHorY(YAHTZEE);
				if (lblYahtzee.text == "0") btnYahtzee.enabled = false;
				break;
			case "chance":
				lblChance.text = totalAllDice().toString();
				btnChance.enabled = false;
				break;
		} //end switch
		
		//update all score fields
		updateScores();
		
		//increase round count and check if game is over
		++roundCount;
		if (roundCount == 13) isGameOver = true;
		
		//reset dice section
		if(!isGameOver) {
			btnRoll.enabled = true;
			currRollCount = 0;
			for (var i:Number = 0; i < dieCheckboxes.length;  ++i)
				dieCheckboxes[i].selected = false;
			for (var j:Number = 0; j < dieLabels.length; ++j)
				dieLabels[j].text = "";
		} //end if
		else {
			btnRoll.enabled = false;
			lblGameOver.visible = true;
		} //end else
		
		hasScoredThisRound = true;
	} //end if
} //end function score

/*********************
 * PRIVATE FUNCTIONS *
 *********************/

private function getRandomNumberRange(min:Number, max:Number):Number {
	return Math.random() * (max - min) + min;
} //end method getRandomNumberRange

private function getRandomNumber():Number {
	return Math.round(Math.random() * 5) + 1;
} //end function getRandomNumber

private function scoreUpper(num:Number):String {
	var score:Number = 0;
	var currScore:Number = 0;
	for each(var lbl:Label in dieLabels) {
		currScore = parseInt(lbl.text, 10);
		if (currScore == num) score += currScore;
	} //end foreach
	
	return score.toString();
} //end function scoreUpper

private function scoreOfKinds(type:Number):String {
	var score:Number = 0;
	var minCount:Number = type;
	var canBeJoker:Boolean = canUseAsJoker();
	
	if (canBeJoker) score = totalAllDice();
	else {
		resetDieNums();
		var dieVal:Number = 0;
		for each(var lbl:Label in dieLabels) {
			dieVal = parseInt(lbl.text, 10);
			++dieNums[dieVal];
			if (dieNums[dieVal] >= minCount) {
				score = totalAllDice();
				break;
			} //end if
		} //end foreach
	} //end else
	
	return score.toString();
} //end function scoreOfKinds

private function scoreStraights(type:Number):String {
	var score:Number = 0;
	var reqConseq:Number = type - 2;
	var canBeJoker:Boolean = canUseAsJoker();
	
	if (canBeJoker) { //use roll as joker if we can
		if (type == SMALL_STRAIGHT) score = 30;
		else if(type == LARGE_STRAIGHT) score = 40;
	} //end if
	else { //score as normal
		//get current numbers and sort them
		var nums:Array = new Array();
		for each(var lbl:Label in dieLabels)
			nums.push(parseInt(lbl.text, 10));
		nums.sort(Array.NUMERIC);
		
		//count number of consecutive numbers
		var consecCount:Number = 0;
		for (var i:Number = nums.length - 1; i > 0; --i) {
			if (nums[i] - nums[i - 1] == 1) ++consecCount;
		} //end for
		
		//score appropriately
		if (consecCount == reqConseq) {
			if (type == SMALL_STRAIGHT) score = 30;
			else if(type == LARGE_STRAIGHT) score = 40;
		} //end if
	} //end else
	
	return score.toString();
} //end function scoreStraights

private function scoreFHorY(type:Number):String {
	var score:Number = 0;
	var canBeJoker:Boolean = canUseAsJoker();
	
	resetDieNums();
	
	//count each number's occurrence
	for each(var lbl:Label in dieLabels)
		++dieNums[parseInt(lbl.text, 10)];
	
	//check for correct hand counts
	if (type == YAHTZEE) {
		if (canBeJoker) score = 50; //use roll as joker if we can
		else { //score field as normal
			for (var i:Number = 1; i <= 6; ++i) {
				if (dieNums[i] == 5) {
					score = 50;
					break;
				} //end if
			} //end for
			
			//check for bonus
			if (lblYahtzee.text == "50" && score == 50) {
				if (lblBonusYahtzee.text == "") lblBonusYahtzee.text = "100";
				else lblBonusYahtzee.text = (parseInt(lblBonusYahtzee.text, 10) + 100).toString();
			} //end if
		} //end else
	} //end if
	else if (type == FULL_H0USE) {
		if (canBeJoker) score = 25; //use roll as joker if we can
		else { //score field as normal
			var found2:Boolean = false;
			var found3:Boolean = false;
			
			for (var j:Number = 1; j <= 6; ++j) {
				if (dieNums[j] == 2) found2 = true;
				else if (dieNums[j] == 3) found3 = true;
				
				if (found2 && found3) {
					score = 25;
					break;
				} //end if
			} //end for
		} //end else
	} //end else/if
	
	return score.toString();
} //end function scoreFHorY

private function canUseAsJoker():Boolean {
	//check Yahtzee has a score
	if (lblYahtzee.text == "") return false
	
	//check that the roll was a Yahtzee roll
	var isYahtzee:Boolean = false;
	resetDieNums();
	for each(var lbl:Label in dieLabels)
		++dieNums[parseInt(lbl.text, 10)];
	for (var i:Number = 1; i <= 6; ++i) {
		if (dieNums[i] == 5) {
			isYahtzee = true;
			break;
		} //end if
	} //end for
	if (!isYahtzee) return false;
	
	//check that the corresponding category is filled
	var upperLabels:Array = [lbl1, lbl2, lbl3, lbl4, lbl5, lbl6];
	var val:Number = parseInt(dieLabels[0].text, 10);
	return upperLabels[val - 1].text != "";
} //end function canUseAsJoker

private function resetDieNums():void {
	for (var i:Number = 1; i <= 6; ++i) 
		dieNums[i] = 0;
} //end function resetDieNums

private function totalAllDice():Number {
	var total:Number = 0;
	for each(var dieLbl:Label in dieLabels)
		total += parseInt(dieLbl.text, 10);
		
	return total;
} //end function totalAllDice

private function updateScores():void {
	var scoredTotal:Number = 0;
	var upperTotal:Number = 0;
	var lowerTotal:Number = 0;
	var overallTotal:Number = 0;
	
	/* score upper section */
	scoredTotal += lbl1.text == "" ? 0 : parseInt(lbl1.text, 10);
	scoredTotal += lbl2.text == "" ? 0 : parseInt(lbl2.text, 10);
	scoredTotal += lbl3.text == "" ? 0 : parseInt(lbl3.text, 10);
	scoredTotal += lbl4.text == "" ? 0 : parseInt(lbl4.text, 10);
	scoredTotal += lbl5.text == "" ? 0 : parseInt(lbl5.text, 10);
	scoredTotal += lbl6.text == "" ? 0 : parseInt(lbl6.text, 10);
	lblScored.text = scoredTotal.toString();
	if (scoredTotal >= 63) {
		lblBonus.text = "35";
		scoredTotal += 35;
	} //end if
	lblUpper.text = scoredTotal.toString();
	
	/* score lower section */
	lowerTotal += lbl3Kind.text == "" ? 0 : parseInt(lbl3Kind.text, 10);
	lowerTotal += lbl4Kind.text == "" ? 0 : parseInt(lbl4Kind.text, 10);
	lowerTotal += lblFullHouse.text == "" ? 0 : parseInt(lblFullHouse.text, 10);
	lowerTotal += lblSm.text == "" ? 0 : parseInt(lblSm.text, 10);
	lowerTotal += lblLg.text == "" ? 0 : parseInt(lblLg.text, 10);
	lowerTotal += lblYahtzee.text == "" ? 0 : parseInt(lblYahtzee.text, 10);
	lowerTotal += lblChance.text == "" ? 0 : parseInt(lblChance.text, 10);
	lblLower.text = lowerTotal.toString();
	
	/* update overall total */
	overallTotal = scoredTotal + lowerTotal + parseInt(lblBonusYahtzee.text, 10);
	lblGameTotal.text = overallTotal.toString();
} //end function updateScores

private function doFireworks():void {
	//create particle for launch
	particle = new Particle(new YellowDot(), this, 275, 500);
	particle.xVelocity = getRandomNumberRange(-5, 5);
	particle.yVelocity = getRandomNumberRange(-8, -15);
	particle.clip.scaleX = particle.clip.scaleY = 0.2;
	particle.drag = .99;
	particle.fade = 0.025;
	particle.gravity = 0.1;
	particle.shrink = 0.98; 
	
	launch.play(); //play launch sound
	addEventListener(Event.ENTER_FRAME, launchFirework); //begin firework launch
} //end method doFireworks

private function launchFirework(e:Event):void {
	//update tail particle
	if (particle != null) particle.update();
	
	//once the tail particle has almost completely disappeared, explode
	if (particle.clip.scaleX <= CRITICAL_SCALE) {
		var xPos:Number = particle.clip.x;
		var yPos:Number = particle.clip.y;
		particle.destroy();
		particle = null;
		removeEventListener(Event.ENTER_FRAME, launchFirework);
		
		/* create new explosion particles */
		boomParticleCount = getRandomNumberRange(50, 80);
		var dotRnd:Number = Math.round(getRandomNumberRange(0, 5));
		
		while (particles.length < boomParticleCount) {
			//define new particle characteristics
			switch(dotRnd) {
				case 0:
					particle = new Particle(new BlueDot(), this, xPos, yPos);
					break;
				case 1:
					particle = new Particle(new GreenDot(), this, xPos, yPos);
					break;
				case 2:
					particle = new Particle(new OrangeDot(), this, xPos, yPos);
					break;
				case 3:
					particle = new Particle(new PurpleDot(), this, xPos, yPos);
					break;
				case 4:
					particle = new Particle(new RedDot(), this, xPos, yPos);
					break;
				case 5:
					particle = new Particle(new WhiteDot(), this, xPos, yPos);
					break;
			} //end switch
			
			particle.xVelocity = getRandomNumberRange( -7, 7);
			particle.yVelocity = getRandomNumberRange( -7, 7);
			particle.clip.scaleX = particle.clip.scaleY = getRandomNumberRange(CRITICAL_SCALE, .5);
			particle.drag = 1;
			particle.fade = 0.02;
			particle.gravity = 0.1;
			particle.shrink = 0.95;
			
			//find the largest scaled particle
			if (particle.clip.scaleX > scaleMax) {
				scaleMaxIdx = pIdx;
				scaleMax = particle.clip.scaleX;
			} //end if
			++pIdx;
			
			//add new particle to array
			particles.push(particle);
		} //end while
		
		explosion.play();
		addEventListener(Event.ENTER_FRAME, doExplosion);
	} //end if
} //end method launchFirework

private function doExplosion(e:Event):void {
	//update all current particles
	for each(var p:Particle in particles) p.update();
	
	//remove the listener and destroy the particles list once the largest particle has dissipated
	if (particles.length >= boomParticleCount) {
		if (particles[scaleMaxIdx].clip.scaleX <= CRITICAL_SCALE) { //if the largest particle has dissipated
			/* reset counters */
			scaleMax = 0;
			scaleMaxIdx = 0;
			pIdx = 0;
			boomParticleCount = 0;
			
			//destroy particles list
			while (particles.length > 0) {
				particle = particles.shift();
				particle.destroy();
				particle = null;
			} //end if

			//stop explosion particles updating
			removeEventListener(Event.ENTER_FRAME, doExplosion);
			System.gc();
			System.gc();
			
			//launch fireworks three times
			if (++fwCount < 3) doFireworks();
			else fwCount = 0;
		} //end if
	} //end if
} //end method onEnterFrame