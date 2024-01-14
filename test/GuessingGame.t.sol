// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {GuessingGame} from "../src/GuessingGame.sol";

contract GuessingGameTest is Test {
    GuessingGame public guessingGame;

    function setUp() public {
        guessingGame = new GuessingGame(42);
    }

    function testGuess() public {
        console2.log(guessingGame.getHighScore());
        guessingGame.guess(31);
        guessingGame.guess(42);
        console2.log(guessingGame.getHighScore());
    }
}
