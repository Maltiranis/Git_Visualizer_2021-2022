using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine.SceneManagement;

public class sc_LapAchieved : MonoBehaviourPunCallbacks
{
    public string _checkPointTag = "checkpoint";
    public string _lapCheckTag = "lapcheck";

    public int _currentLap = 1;
    public int _lastLap = 3;
    public int _currentCheckpoint = 0;
    //int _checkpointsArrayLenght;

    public string _myTime = "00:00";
    public PhotonView PV;

    public int min = 0;
    public int sec = 0;

    public int _secondsSpends = 0;
    public int _checkpointTime = 0;
    public int _lapTime = 0;
    public int _previousLapTime = 0;

    public int _checkStatus;
    public GameObject[] checkpoints;

    [SerializeField] public GameObject _CanvasUI;
    [SerializeField] private Transform _scoreContainer;
    [SerializeField] private GameObject _scoreListingPrefab;
    [SerializeField] private GameObject _WinnerPannel;

    [SerializeField] private GameObject[] _racers;
    [SerializeField] public GameObject[] scoreChildEngage;

    bool settedUp = false;

    public List<GameObject> _sortedScores = new List<GameObject>();
    public GameObject _master;

    void Start()
    {
        PV = GetComponent<PhotonView>();

        if (!PV.IsMine)
        {
            _CanvasUI.SetActive(false);
        }
        else
        {
            if (GetComponent<sc_IA_PodEnginePUN>() != null)
            {
                _CanvasUI.SetActive(false);
            }
            else
            {
                StartCoroutine(ListScoresEnum());

                /*if (PV.Owner.NickName == PhotonNetwork.PlayerList.ToArray()[0].NickName)
                    _master = gameObject;*/
            }
        }

        if (GetComponent<sc_IA_PodEnginePUN>() != null)
        {
            _CanvasUI.SetActive(false);
        }

        checkpoints = GameObject.FindGameObjectsWithTag(_checkPointTag);

        StartCoroutine(chronometer()); //Wrong place ?
        _WinnerPannel.SetActive(false);
    }

    void Update()
    {
        if (_currentCheckpoint > checkpoints.Length)
            _currentCheckpoint = 0;

        if (settedUp == true)
        {
            Scores();
        }

        if (_racers.Length == 0)
        {
            _racers = GameObject.FindGameObjectsWithTag("racers");
        }
        /*if (_master == null)
        {
            foreach (GameObject r in _racers)
            {
                if (r.GetComponent<sc_LapAchieved>()._master != null)
                {
                    _master = r.GetComponent<sc_LapAchieved>()._master;
                    if (_master != null)
                        PV.RPC("SyncMaster", RpcTarget.AllBuffered, _master.name);
                }
            }
        }*/
    }

    void Scores()
    {
        if (PV.IsMine)
        {
            if (checkpoints[_currentCheckpoint].transform != null)
                PV.RPC("SyncScores", RpcTarget.AllBuffered, gameObject.name, _secondsSpends, _currentLap, _currentCheckpoint, checkpoints[_currentCheckpoint].transform.position, _myTime, _checkStatus, min, sec);

            //PB : laptime convertis pas en mytime

            for (int i = 0; i < _racers.Length; i++) //Ce truc est problematique
            {
                scoreChildEngage[i].name = _racers[i].name;// GetComponent<sc_LapAchieved>()._checkStatus.ToString();

                scoreChildEngage[i].transform.GetChild(0).GetComponent<TextMeshProUGUI>().text = scoreChildEngage[i].transform.GetChild(0).GetComponent<TextMeshProUGUI>().text;
                //scoreChildEngage[i].transform.GetChild(1).GetComponent<TextMeshProUGUI>().text = scoreChildEngage[i].name;
                scoreChildEngage[i].transform.GetChild(1).GetComponent<TextMeshProUGUI>().text = _racers[i].GetComponent<sc_LapAchieved>()._myTime;
            }

            //List<GameObject> newL = new List<GameObject>();
            //_sortedScores = scoreChildEngage.OrderByDescending(go => int.Parse(go.name)).ToList();

            if (checkpoints[_currentCheckpoint].transform != null)
                _sortedScores = _racers.ToList().OrderBy(go => go.GetComponent<sc_LapAchieved>()._currentLap).
                ThenBy(go => go.GetComponent<sc_LapAchieved>()._currentCheckpoint).
                ThenByDescending(go => go.GetComponent<sc_LapAchieved>().DistToNextCP(checkpoints[_currentCheckpoint].transform.position)).ToList();//ThenBy ?

            for (int i = 0; i < _sortedScores.ToArray().Length; i++)
            {
                for (int j = 0; j < scoreChildEngage.Length; j++)
                {
                    if (_sortedScores.ToArray()[i].name == scoreChildEngage[j].name)
                    {
                        scoreChildEngage[j].transform.SetAsFirstSibling();
                    }
                }
            }
        }
    }

    /*[PunRPC]
    public void SyncMaster(string mName)
    {
        for (int i = 0; i < _racers.Length; i++)
        {
            if (_racers[i].name == mName)
            {
                _master = _racers[i];
            }
        }
    }*/

    [PunRPC]
    void SyncScores(string myName, int sS, int cL, int cC, Vector3 cP, string mT, int cS, int m, int s)
    {
        gameObject.name = myName;
        _secondsSpends = sS;
        _currentLap = cL;
        _currentCheckpoint = cC;
        checkpoints[_currentCheckpoint].transform.position = cP;
        _myTime = mT;
        _checkStatus = cS;
        min = m;
        sec = s;
    }

    float DistToNextCP(Vector3 nextCP)
    {
        float dist;

        dist = Vector3.Distance(transform.position, nextCP);

        return dist;
    }

    public void ListScores()
    {
        for (int i = 0; i < _racers.Length; i++)
        {
            GameObject tempListing = Instantiate(_scoreListingPrefab, _scoreContainer);
        }

        scoreChildEngage = new GameObject[_racers.Length];

        for (int i = 0; i < _racers.Length; i++)
        {
            scoreChildEngage[i] = transform.GetChild(0).transform.GetChild(0).transform.GetChild(2).transform.GetChild(0).transform.GetChild(0).transform.GetChild(0).transform.GetChild(i).gameObject;
            scoreChildEngage[i].name = _racers[i].GetComponent<sc_LapAchieved>()._checkpointTime.ToString();

            scoreChildEngage[i].transform.GetChild(0).GetComponent<TextMeshProUGUI>().text = _racers[i].name;
            scoreChildEngage[i].transform.GetChild(1).GetComponent<TextMeshProUGUI>().text = scoreChildEngage[i].name;

            /*if (!_sortedScores.Contains(scoreChildEngage[i]))
                _sortedScores.Add(scoreChildEngage[i]);*/
        }
    }

    IEnumerator chronometer()
    {
        yield return new WaitForSeconds(1);
        _secondsSpends++;
        _previousLapTime++;

        StartCoroutine(chronometer());
    }

    IEnumerator ListScoresEnum()
    {
        yield return new WaitForSeconds(2);

        _racers = GameObject.FindGameObjectsWithTag("racers");
        ListScores();

        settedUp = true;
    }

    public void OnTriggerEnter(Collider other)
    {
        if (other.tag == _checkPointTag)
        {
            _checkpointTime = _secondsSpends;

            if (_currentCheckpoint >= checkpoints.Length)
                _currentCheckpoint = 0;
            else
                _currentCheckpoint++;

            if (_currentCheckpoint >= checkpoints.Length)
                _currentCheckpoint = 0;

            _checkStatus = int.Parse((1000 * _currentLap).ToString() + _currentCheckpoint.ToString() + _checkpointTime.ToString());
        }
        if (other.tag == _lapCheckTag)
        {
            _lapTime = _previousLapTime;

            if (_currentLap == _lastLap)
            {
                _WinnerPannel.SetActive(true);
                foreach (GameObject r  in _racers)
                {
                    r.GetComponent<Rigidbody>().isKinematic = true;

                    if (r.GetComponent<sc_IA_PodEnginePUN>() == null)
                        r.GetComponent<sc_LapAchieved>().BackToMenu();
                }
            }
            else
                _currentLap += 1;
            _checkStatus = int.Parse((1000 * _currentLap).ToString() + _currentCheckpoint.ToString() + _checkpointTime.ToString());

            min = Mathf.FloorToInt(_lapTime / 60f);
            sec = Mathf.FloorToInt(_lapTime - min * 60);

            _myTime = string.Format("{0:00}:{1:00}", min, sec);

            _previousLapTime = 0;
        }
    }

    public void BackToMenu()
    {
        StartCoroutine(LoadMenu());
    }

    IEnumerator LoadMenu()
    {
        yield return new WaitForSeconds(5);
        LoadLevel();
    }

    public void LoadLevel()
    {
        if (PhotonNetwork.InRoom)
            PhotonNetwork.LeaveRoom();
        //SceneManager.LoadScene(0);
        //Time.timeScale = 1f;
    }
}
