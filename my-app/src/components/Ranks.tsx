import {useEffect, useState} from "react"

type BattingPlayer = {
    id: number;
    points: number;
    playerName: string;
    matches: number;
    playerRuns: number;
    battingAverage: number;
    strikeRate: number;
    boundaries: number;
}

type BowlingPlayer = {
    id: number;
    points: number;
    playerName: string;
    matches: number;
    wickets: number;
    bowlingAverage: number;
    strikeRate: number;
    economy: number;
}

function Ranking () {
    const [batting, setBattingPlayers] = useState<BattingPlayer[]>([]);
    const [bowling, setBowlingPlayers] = useState<BowlingPlayer[]>([]);
    const [unique, setUnique] = useState(1);
    useEffect(() => 
    {
        const fetchRankedPlayers = async () => {
            try { 
                // connecting to db
            } catch (error) {
                console.error("error fetching ranked players", error)
            }
        };
        console.log("running the fetch function...")
        fetchRankedPlayers();
    }, [])

    return(
        <div className = "rank">
            <div className="container">
                <div className="row">
                    <div className="col-lg">
                        <div>
                        <button onClick={() => setUnique(0)} className={unique === 0? "offbtn" : "togglebtn"}>Batting</button>
                        <button onClick={() => setUnique(1)} className={unique === 1? "offbtn" : "togglebtn"}>Bowling</button>
                        </div>
                    </div>
                </div>
            </div>
            <div className={unique === 0? "showContent" : "rankcontent"}>
            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Points</th>
                        <th>Name</th>
                        <th>Matches</th>
                        <th>Runs</th>
                        <th>Average </th>
                        <th>Strike Rate</th>
                        <th>boundaries</th>
                    </tr>
                </thead>
                <tbody>
                    {batting.map((player, index) => (
                        <tr key ={player.id}>
                            <td>{index + 1}</td>
                            <td>{player.points}</td>
                            <td>{player.playerName}</td>
                            <td>{player.matches}</td>
                            <td>{player.playerRuns}</td>
                            <td>{player.battingAverage}</td>
                            <td>{player.strikeRate}</td>
                            <td>{player.boundaries}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
            </div>
            <div className={unique === 1? "showContent" : "rankcontent"}>
            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>points</th>
                        <th>name</th>
                        <th>Matches</th>
                        <th>Wickets</th>
                        <th>Economy</th>
                        <th>Average </th>
                        <th>Strike Rate</th>
                    </tr>
                </thead>
                <tbody>
                    {bowling.map((player, index) => (
                        <tr key ={player.id}>
                            <td>{index + 1}</td>
                            <td>{player.points}</td>
                            <td>{player.playerName}</td>
                            <td>{player.matches}</td>
                            <td>{player.wickets}</td>
                            <td>{player.economy}</td>
                            <td>{player.bowlingAverage}</td>
                            <td>{player.strikeRate}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
            </div>
        </div>
    )
}

export default Ranking;