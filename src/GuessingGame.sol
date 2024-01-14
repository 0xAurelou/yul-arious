// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract GuessingGame {
    uint public numberToGuess;
    uint public highScore; // Set initial high score to maximum uint value
    address public bestPlayer;
    mapping(address => uint) public userScores;
    mapping(address => uint) public numberOfTry;
    mapping(address => bool) public userHaveFound;

    // Constructor to initialize the contract with a specific number
    constructor(uint number_) {
        assembly {
            sstore(numberToGuess.slot, number_)
            sstore(highScore.slot, 128)
        }
    }

    // Function for users to make a guess
    function guess(uint numberGuessed) external {
        uint numberToBeFound;
        uint numberOfTentative;
        uint currentHighScore;
        uint highScoreSlot;
        uint userHaveFoundSlot;
        uint userScoreSlot;
        uint tentativeSlot;
        assembly {
            // Calculate storage location for user's "userHaveFound" flag
            userHaveFoundSlot := userHaveFound.slot
            userScoreSlot := userScores.slot
            tentativeSlot := numberOfTry.slot
        }

        bytes32 userHaveFoundLocation = keccak256(
            abi.encode(msg.sender, userHaveFoundSlot)
        );

        bytes32 tentativeLocation = keccak256(
            abi.encode(msg.sender, tentativeSlot)
        );

        assembly {
            // Check if the user has already found the number
            if iszero(iszero(sload(userHaveFoundLocation))) {
                revert(0, 0)
            }
            // Load necessary values
            numberToBeFound := sload(numberToGuess.slot)
            highScoreSlot := highScore.slot
            currentHighScore := sload(highScoreSlot)
            numberOfTentative := sload(tentativeLocation)

            // Increment number of tries
            sstore(tentativeLocation, add(numberOfTentative, 1))
        }

        bytes32 userScoresLocation = keccak256(
            abi.encode(msg.sender, userScoreSlot)
        );

        assembly {
            // Check if the guessed number is correct
            if eq(numberToBeFound, numberGuessed) {
                // Update userScores and userHaveFound
                sstore(userScoresLocation, add(numberOfTentative, 1))
                sstore(userHaveFoundLocation, 1)

                // Update high score and best player if new score is better
                if lt(currentHighScore, add(numberOfTentative, 1)) {
                    sstore(highScoreSlot, add(numberOfTentative, 1))
                    sstore(bestPlayer.slot, caller())
                }
            }
        }
    }

    // Function to get the number of tries for a specific user
    function getNumberOfGuess(address user) external view returns (uint) {
        uint numberSlot;
        assembly {
            numberSlot := numberOfTry.slot
        }

        bytes32 tentativeLocation = keccak256(abi.encode(user, numberSlot));

        uint numbers;
        assembly {
            numbers := sload(tentativeLocation)
        }
        return numbers;
    }

    // Function to get the current high score
    function getHighScore() external view returns (uint) {
        uint highScores;
        assembly {
            let highScoreSlot := highScore.slot
            highScores := sload(highScoreSlot)
        }
        return highScores;
    }
}
