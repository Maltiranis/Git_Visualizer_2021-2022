using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sc_SpaceShip_IA01 : MonoBehaviour
{
    [Header("Parameters")]
    [Tooltip("Combat specific")] public float actionLimit = 200.0f;
    [Tooltip("Combat specific")] public float shortestDistToTarget = 2.0f;
    [Tooltip("Ship specific")] public float linSpeed = 1.0f;
    [Tooltip("Ship specific")] public float rotSpeed = 1.0f;

    [Header("Target")]
    public Transform _target = null;
    Vector3 targetPos;

    [Header("Is mobile or not")]
    public bool staticPos = false;

    [Header("Is patrolling or not")]
    Vector3 patrolThere;
    public bool patroling = false;

    [Header("Combat")]
    public int _myFaction = 0;
    [Range(1, 100)] public float _radarRefreshingRate = 1.0f;
    [SerializeField] public List<GameObject> enemyList;
    [SerializeField] public List<GameObject> friendList;

    [Header("Squad")]
    public bool _squadLeader = false;
    public GameObject sLeader = null;
    public bool leaderPresent = false;
    [Tooltip("Combat specific")] public float abortChasing = 20.0f;
    [Tooltip("Ship specific")] public Vector3 squadFormationPosition;
    [Tooltip("Ship specific")] public Vector3 squadEspacementOffset = new Vector3(2, 0, 2);

    public int pairsCounts = 0;
    public int multiplyMates = 1;
    bool squadAsigned = false;
    [SerializeField] public List<GameObject> mySquadPoints = new List<GameObject>();
    GameObject emptyOne;
    Transform squadTarget;

    private void Start()
    {
        GetShipList();
        StartCoroutine(DRADIS());
        pairsCounts = 0;
    }

    void Update()
    {
        MovingBrain();
        SquadBrain();
        CombatBrain();
    }

    private void SquadBrain ()
    {
        if (friendList.ToArray().Length > 0)
        {
            CheckForLeader(friendList.ToArray());
            if (!leaderPresent)
            {
                CheersCaptain();
            }

            if (_squadLeader)
            {
                pairsCounts = 0;
                multiplyMates = 1;
                AssignPositionsInSquad(friendList.ToArray());
            }

            if (!_squadLeader && leaderPresent)
            {
                targetPos = squadFormationPosition;
            }
        }
    }

    void AssignPositionsInSquad (GameObject[] squadMates)
    {
        int onRight = 1;

        if (_target == false)
        {
            foreach (GameObject sp in mySquadPoints)
            {
                Destroy(sp);
            }
            mySquadPoints.Clear();
            squadAsigned = false;
        }

        if (squadAsigned == false)
        {
            emptyOne = new GameObject("Hey it's me !");

            mySquadPoints.Add(emptyOne);
            mySquadPoints.ToArray()[0].name = gameObject.name + " Team " + _myFaction + " squadPoint";
            mySquadPoints.ToArray()[0].transform.position = transform.position;

            for (int i = 1; i < squadMates.Length; i++)
            {
                if (i % 2 == 0)
                {
                    onRight = 1;
                }
                else
                {
                    onRight = -1;
                }

                emptyOne = new GameObject();
                mySquadPoints.Add(emptyOne);
                mySquadPoints.ToArray()[i].name = mySquadPoints.ToArray()[i].gameObject.name + " Team " + _myFaction + " squadPoint";
                mySquadPoints.ToArray()[i].transform.parent = mySquadPoints.ToArray()[0].transform;

                mySquadPoints.ToArray()[i].transform.position = new Vector3
                (
                    mySquadPoints.ToArray()[0].transform.position.x + (onRight * squadEspacementOffset.x * multiplyMates),
                    squadEspacementOffset.y,
                    mySquadPoints.ToArray()[0].transform.position.z - (squadEspacementOffset.z * multiplyMates)
                );

                if (i > 1)
                {
                    if (pairsCounts % 2 == 0)
                    {
                        multiplyMates++;
                    }
                    pairsCounts++;
                }

                if (enemyList.ToArray().Length < 1)
                {
                    squadMates[i].GetComponent<sc_SpaceShip_IA01>()._target = mySquadPoints.ToArray()[i].transform;
                    squadMates[i].GetComponent<sc_SpaceShip_IA01>().squadTarget = mySquadPoints.ToArray()[i].transform;
                }
            }
            squadAsigned = true;
        }

        mySquadPoints.ToArray()[0].transform.position = transform.position;
        mySquadPoints.ToArray()[0].transform.forward = Vector3.Lerp(mySquadPoints.ToArray()[0].transform.forward, transform.forward, rotSpeed / 200);
    }

    void CheckForLeader (GameObject[] squadMembers)
    {
        for (int i = 0; i < friendList.ToArray().Length; i++)
        {
            if (friendList.ToArray()[i].GetComponent<sc_SpaceShip_IA01>()._squadLeader == true)
            {
                leaderPresent = true;
                break;
            }
            else
                leaderPresent = false;
        }
    }

    private void CheersCaptain()
    {
        friendList.ToArray()[0].GetComponent<sc_SpaceShip_IA01>()._squadLeader = true;
        sLeader = friendList.ToArray()[0];
        sLeader.name = ("Captain " + 0);

        for (int i = 0; i < friendList.ToArray().Length; i++)
        {
            friendList.ToArray()[i].GetComponent<sc_SpaceShip_IA01>().leaderPresent = true;
            friendList.ToArray()[i].GetComponent<sc_SpaceShip_IA01>().sLeader = sLeader;
        }
    }

    private void CombatBrain ()
    {
        if (enemyList.ToArray().Length > 0 && enemyList != null && enemyList.ToArray()[0] != null)
        {
            _target = GetClosestEntity(enemyList).transform;
            if (Vector3.Distance(transform.position, _target.position) > abortChasing)
            {
                if (squadTarget != null)
                    _target = squadTarget;
            }
        }
    }

    private void MovingBrain ()
    {
        if (Vector3.Distance(transform.position, Vector3.zero) < actionLimit)
        {
            if (staticPos == false)
            {
                if (_target != null)
                {
                    MoveToTarget(_target.position);
                }
                else
                {
                    if (leaderPresent && !_squadLeader)
                    {
                        MoveToTarget(squadFormationPosition);
                        //Debug.Log("squadFormationPosition");
                    }
                }
            }
        }
    }

    private void MoveToTarget (Vector3 target)
    {
        float dist = Vector3.Distance(transform.position, target);
        Vector3 dir = target - transform.position;

        if (dist > shortestDistToTarget)
        {
            transform.forward = Vector3.Lerp(transform.forward, dir, rotSpeed / 100);
        }
        else
        {
            if (sLeader != null)
            {
                if (!_squadLeader)
                {
                    transform.forward = Vector3.Lerp(transform.forward, sLeader.transform.forward, rotSpeed / 100);
                }
            }
        }

        if (dist > shortestDistToTarget && dist != 0.0f)
        {
            transform.position += dir * linSpeed / 100 / dist;
        }
    }

    GameObject GetClosestEntity (List<GameObject> enemies)
    {
        GameObject bestTarget = null;
        float closestDistanceSqr = Mathf.Infinity;
        Vector3 currentPosition = transform.position;

        foreach(GameObject potentialTarget in enemies)
        {
            Vector3 directionToTarget = potentialTarget.transform.position - currentPosition;
            float dSqrToTarget = directionToTarget.sqrMagnitude;

            if(dSqrToTarget < closestDistanceSqr)
            {
                closestDistanceSqr = dSqrToTarget;
                bestTarget = potentialTarget;
            }
        }             
        return bestTarget;
    }

    void GetShipList()
    {
        GameObject[] shipList = GameObject.FindGameObjectsWithTag("SpaceShip");

        enemyList.Clear();
        friendList.Clear();

        for (int i = 0; i < shipList.Length; i++)
        {
            if (shipList[i].GetComponent<sc_SpaceShip_IA01>()._myFaction != _myFaction)
            {
                enemyList.Add(shipList[i]);
            }
            else
            {
                friendList.Add(shipList[i]);
            }
        }
    }

    IEnumerator DRADIS ()
    {
        yield return new WaitForSeconds(_radarRefreshingRate);

        GetShipList();

        StartCoroutine(DRADIS());
    }
}
