using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using System.Net.Sockets;
using System.Net;
using System.Threading;

using Newtonsoft.Json;
using PCLStorage;

namespace FRCDetective
{
    public partial class MainPage : ContentPage
    {
        bool _netStatus = false;
        bool _lastNetStatus = false;

        private static Connection _instance;
        private TcpClient client;
        private Socket socket;
        private bool isLoaded;


        private Settings settings = new Settings();

        // Initialise the page and set the connection icon to not connected
        public MainPage()
        {
            InitializeComponent();
            NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");
        }

        // When the page appears, start the network connection task
        protected async override void OnAppearing()
        {
            NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("Config", CreationCollisionOption.OpenIfExists);
            IFile file = await folder.CreateFileAsync("settings", CreationCollisionOption.OpenIfExists);

            settings = JsonConvert.DeserializeObject<Settings>(await file.ReadAllTextAsync());

            isLoaded = true;
            Task.Run(async () =>
            {
                await networkInterface();
            });

            UpdateToSync();
        }

        // When the page disappears, kill the network connection task
        protected async override void OnDisappearing()
        {
                isLoaded = false;
        }

        // Update the number of rounds left to sync
        async void UpdateToSync()
        {
            int toSync = 0;
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);

            foreach (IFile file in await folder.GetFilesAsync())
            {
                RoundData round = JsonConvert.DeserializeObject<RoundData>(await file.ReadAllTextAsync());
                if (!round.Synced)
                {
                    toSync += 1;
                }
            }
            LabelToSync.Text = toSync.ToString();
        }

        // If the client is not connected to the server, attemt to connect every second. On state change, update the icon
        async Task networkInterface()
        {
            while (true)
            {
                _netStatus = IsConnected;
                if (!_netStatus)
                {
                    connect();
                }

                if (_netStatus == false && _lastNetStatus == true)
                {
                    Device.BeginInvokeOnMainThread(() =>
                    {
                        NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");
                    });
                }
                else if (_netStatus == true && _lastNetStatus == false)
                {
                    Device.BeginInvokeOnMainThread(() =>
                    {
                        NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_black_18dp.png");
                    });
                    _netStatus = true;
                    //send();
                }
                _lastNetStatus = _netStatus;

                if (!isLoaded)
                {
                    return;
                }

                Thread.Sleep(1000);
            }
        }

        // A function to determine if the client is connected to the server
        public bool IsConnected
        {
            get
            {
                try
                {
                    if (client != null && client.Client != null && client.Client.Connected)
                    {
                        /* pear to the documentation on Poll:
                         * When passing SelectMode.SelectRead as a parameter to the Poll method it will return 
                         * -either- true if Socket.Listen(Int32) has been called and a connection is pending;
                         * -or- true if data is available for reading; 
                         * -or- true if the connection has been closed, reset, or terminated; 
                         * otherwise, returns false
                         */

                        // Detect if client disconnected
                        if (client.Client.Poll(0, SelectMode.SelectRead))
                        {
                            byte[] buff = new byte[1];
                            if (client.Client.Receive(buff, SocketFlags.Peek) == 0)
                            {
                                // Client disconnected
                                return false;
                            }
                            else
                            {
                                return true;
                            }
                        }

                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                catch
                {
                    return false;
                }
            }
        }

        // Transition to the GameEntryPage
        async void entryPage(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new LoadingPage(new NewGameEntryPage(), "Game Entry Page"));
        }

        async void SettingsPage(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new SettingsPage());
        }

        async void AnalysisPage(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new LoadingPage(new AnalysisPage(), "Analysis Page"));
        }

        async void FileViewPage(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new FileViewPage());
        }
        async void SettingsPg(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new SettingsPage());
        }

        // Attempt a connection to the client
        void connect()
        {
            try
            {
                client = new TcpClient();

                var result = client.BeginConnect(settings.IP, settings.Port, null, null);

                var success = result.AsyncWaitHandle.WaitOne(TimeSpan.FromSeconds(1));

                if (!success)
                {
                    throw new Exception("Failed to connect.");
                }

                // we have connected
                client.EndConnect(result);
            }
            catch (Exception e)
            {
                //DisplayAlert("Error", e.Message, "OK");
                Console.WriteLine(e.Message);
            }
        }

        /* Main function for sending data
         * 
         * Inputs:
         *     - Byte Array data: data to send over the TCP socket
         *     - Bool autoRetry: whether to keep resending data until a RECV_OK message is received
         * Outputs:
         *     - True: Data was sent successfully
         *     - False: Data was not sent successfully
         */
        bool send(byte[] data, bool autoRetry = true)
        {
            bool replyOK = false;


            while (!replyOK)
            {
                try
                {
                    client.SendTimeout = 5000;
                    NetworkStream stream = client.GetStream();
                    stream.Write(data, 0, data.Length);
                }
                catch (Exception e)
                {
                    DisplayError(e.Message);
                    return false;
                }

                if (!autoRetry)
                {
                    return true;
                }

                byte[] ok = { 0x52, 0x45, 0x43, 0x56, 0x5f, 0x4f, 0x4b };
                byte[] no = { 0x52, 0x45, 0x43, 0x56, 0x5f, 0x45, 0x52 };
                byte[] dc = { 0x52, 0x45, 0x43, 0x56, 0x5f, 0x44, 0x43 };

                byte[] reply = receive();

                if (reply == null)
                {
                    //DisplayError("Server Sent No Reply. Are you connected to the server?");
                    return false;
                }

                if (Enumerable.SequenceEqual(reply, ok))
                {
                    //DisplayAlert("Message", "Yay the data is good", ":)");
                    replyOK = true;
                }
                else if (Enumerable.SequenceEqual(reply, no))
                {
                    //DisplayError("Blame mitch his server broke");
                    return false;
                }
                else if (Enumerable.SequenceEqual(reply, dc))
                {
                    //DisplayAlert("Message", "Yay the data is good. Disconnecting", ":)");
                    replyOK = true;
                    client.Close();
                }
            }
            return true;
        }

        /* Main Function for Receiving Data
         * 
         * Outputs:
         *     - Byte Array: Data received from the socket
         *     - Byte Array: Null if receive failed
         */
        byte[] receive()
        {
            try
            {
                client.ReceiveTimeout = 5000;
                NetworkStream stream = client.GetStream();
                byte[] data = new byte[1024];

                int bytes = stream.Read(data, 0, data.Length);

                byte[] received = new byte[bytes];

                for (int i = 0; i < bytes; i++)
                {
                    received[i] = data[i];
                }
                return received;
            }
            catch { }

            return null;
        }

        /* Function for syncing data between client and server
         * 
         * Protocol:
         *     - Client initialises list with b'L' as first value
         *     - Client reads files and adds unique ID from each file to list in byte form
         *     - Client sends list to server
         *     
         *     - Server replys with unique ID of rounds it wants
         *     - Server requests data from client
         *     - If client has data to send the server, client sends b'R' followed by full round data
         *     - Client sends b'S' to request data from server
         *     - If server replys b'D' client reads data from socket and saves to file
         */
        async void Index(object sender, EventArgs e)
        {
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);

            List<Byte> dataList = new List<byte>();

            dataList.Add(Encoding.UTF8.GetBytes("L")[0]);

            foreach (IFile file in await folder.GetFilesAsync())
            {
                string json = await file.ReadAllTextAsync();
                RoundData round = JsonConvert.DeserializeObject<RoundData>(json);

                foreach (byte Byte in Encoding.UTF8.GetBytes(round.ID))
                {
                    dataList.Add(Byte);
                }
                foreach (byte Byte in BitConverter.GetBytes(((DateTimeOffset)round.Timestamp).ToUnixTimeSeconds()))
                {
                    dataList.Add(Byte);
                }
            }

            try
            {
                client.SendTimeout = 5000;
                NetworkStream stream = client.GetStream();
                stream.Write(dataList.ToArray(), 0, dataList.Count);
            }
            catch (Exception ex)
            {
                DisplayError(ex.Message);
                return;
            }

            byte[] returnFlag = receive();
            if (Encoding.UTF8.GetString(returnFlag) != "RECV_OK")
            {
                DisplayError("Uh the server didn't like what i sent :(");
                return;
            }

            byte[] returnData = receive();

            if (returnData[0] == Encoding.UTF8.GetBytes("N")[0])
            {
                int IDLength = 13;
                List<string> toSend = new List<string>();

                for (int i = 1; i < returnData.Length; i += IDLength)
                {
                    byte[] tempArray = new byte[IDLength];
                    Array.Copy(returnData, i, tempArray, 0, IDLength);
                    toSend.Add(Encoding.UTF8.GetString(tempArray));
                }

                if (toSend.Count > 0)
                {
                    send(Encoding.UTF8.GetBytes("R"));

                    for (int j = 0; j < toSend.Count; j++)
                    {
                        IFile file = await folder.GetFileAsync(toSend[j] + ".json");
                        string json = await file.ReadAllTextAsync();
                        RoundData round = JsonConvert.DeserializeObject<RoundData>(json);

                        byte[] data = new byte[41];

                        byte[] time = BitConverter.GetBytes(((DateTimeOffset)round.Timestamp).ToUnixTimeSeconds());
                        byte[] team = BitConverter.GetBytes((Int32)round.Team);
                        byte[] hash = BitConverter.GetBytes(CreateHash(round));
                        byte[] UID = BitConverter.GetBytes((Int32)settings.UID);

                        for (int i = 0; i < 4; i++)    // UID
                        {
                            data[i] = UID[i];
                        }
                        for (int i = 4; i < 12; i++)    // Time
                        {
                            data[i] = time[i - 4];
                        }
                        data[12] = Convert.ToByte(round.Division);   // Division
                        data[13] = Convert.ToByte(round.Type);   // Round Type
                        data[14] = Convert.ToByte(round.Round);   // Round Number
                        for (int i = 15; i < 19; i++)    // Team
                        {
                            data[i] = team[i - 15];
                        }
                        data[19] = Convert.ToByte(round.Alliance);   // Alliance
                        /* Auto */
                        data[20] = Convert.ToByte(round.InitLine);   // Initiation Line
                        data[21] = Convert.ToByte(round.AutoHighGoal);   // Top Balls
                        data[22] = Convert.ToByte(round.AutoLowGoal);   // Bottom Balls
                        /* Teleop */
                        data[23] = Convert.ToByte(round.TeleopHighGoal);  // Top Balls
                        data[24] = Convert.ToByte(round.TeleopLowGoal);   // Bottom Balls
                        data[25] = Convert.ToByte(round.ColourwheelRotation);   // Rotation Control
                        data[26] = Convert.ToByte(round.ColourwheelPosition);   // Position Control
                        data[27] = Convert.ToByte(round.Climb);   // Climb
                        data[28] = Convert.ToByte(round.Level);   // Level
                        data[29] = Convert.ToByte(round.Foul);    // Foul
                        data[30] = Convert.ToByte(round.TechFoul);  // Tech Foul
                        data[31] = 0xFF;// Start Hash
                        for (int i = 32; i < 40; i++)   // Hash
                        {
                            data[i] = hash[i-32];
                        }
                        if (j == toSend.Count - 1)
                        {
                            data[40] = 0;   // End Byte
                        }
                        else
                        {
                            data[40] = 1;   // End Byte
                        }

                        if (!send(data))
                        {
                            DisplayError("Error Sending Data");
                            return;
                        }
                        else
                        {
                            round.Synced = true;
                            json = JsonConvert.SerializeObject(round);
                            await file.WriteAllTextAsync(json);
                        }
                    }
                }
            }
            //await DisplayAlert("Done", "Data Has Been Sent", ":D");
            
            send(Encoding.UTF8.GetBytes("S"), false);
            byte[] reply = receive();

            if (Encoding.UTF8.GetString(reply) == "D")
            {
                bool endByte = false;
                while (!endByte)
                {
                    byte[] data = receive();
                    send(Encoding.UTF8.GetBytes("RECV_OK"), false);
                    

                    if (data[40] == 0)
                    {
                        endByte = true;
                    }

                    RoundData roundData = new RoundData();
                    roundData.Synced = true;

                    System.DateTime epochTime = new System.DateTime(1970, 1, 1, 0, 0, 0, 0);    // Time
                    roundData.Timestamp = epochTime.AddSeconds(BitConverter.ToInt64(data, 4));
                    roundData.Division = (sbyte)data[12];                                       // Division
                    roundData.Type = (sbyte)data[13];                                           // Round Type
                    roundData.Round = (sbyte)data[14];                                          // Round Number
                    roundData.Team = BitConverter.ToInt32(data, 15);                            // Team
                    roundData.Alliance = (sbyte)data[19];                                       // Alliance
                    roundData.InitLine = BitConverter.ToBoolean(data, 20);                      // Initiation Line
                    roundData.AutoHighGoal = (sbyte)data[21];                                   // Auto Top Balls
                    roundData.AutoLowGoal = (sbyte)data[22];                                    // Auto Low Goal
                    roundData.TeleopHighGoal = (sbyte)data[23];                                 // Top Balls
                    roundData.TeleopLowGoal = (sbyte)data[24];                                  // Low Balls
                    roundData.ColourwheelRotation = BitConverter.ToBoolean(data, 25);           // Rotation Control
                    roundData.ColourwheelPosition = BitConverter.ToBoolean(data, 26);           // Position Control
                    roundData.Climb = (sbyte)data[27];                                          // Climb
                    roundData.Level = BitConverter.ToBoolean(data, 28);                         // Level
                    roundData.Foul = (sbyte)data[29];                                           // Foul
                    roundData.TechFoul = (sbyte)data[30];                                       // Tech Foul


                    string DisplayName = "";
                    DisplayName += "Round ";
                    DisplayName += roundData.Round.ToString();
                    if (roundData.Alliance != 0) { DisplayName += " Red Alliance "; } else { DisplayName += " Blue Alliance "; }
                    DisplayName += "Team ";
                    DisplayName += roundData.Team.ToString();
                    roundData.DisplayName = DisplayName;


                    string ID = "";
                    ID += roundData.Division.ToString();
                    ID += "-";
                    ID += roundData.Type;
                    ID += "-";
                    ID += roundData.Round.ToString("D3");
                    ID += "-";
                    ID += roundData.Team.ToString("D5");

                    roundData.ID = ID;

                    string FileName = ID + ".json";
                    roundData.Filename = FileName;

                    string json = JsonConvert.SerializeObject(roundData);

                    rootFolder = FileSystem.Current.LocalStorage;
                    folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);
                    IFile file = await folder.CreateFileAsync(FileName, CreationCollisionOption.ReplaceExisting);
                    await file.WriteAllTextAsync(json);
                }
            }
            UpdateToSync();
            DisplayAlert("Done", "Done", "Done");
        }

        long CreateHash(RoundData round)
        {
            long hash = 0;

            byte[] data = new byte[41];

            hash += ((DateTimeOffset)round.Timestamp).ToUnixTimeSeconds();
            hash += round.Team;
            hash += settings.UID;
            hash += round.Division;
            hash += round.Type;
            hash += round.Round;
            hash += round.Alliance;
            hash += Convert.ToInt32(round.InitLine);
            hash += round.AutoHighGoal;
            hash += round.AutoLowGoal;
            hash += round.TeleopHighGoal;
            hash += round.TeleopLowGoal;
            hash += Convert.ToInt32(round.ColourwheelRotation);
            hash += Convert.ToInt32(round.ColourwheelPosition);
            hash += round.Climb;
            hash += Convert.ToInt32(round.Level);
            hash += round.Foul;
            hash += round.TechFoul;

            return hash;
        }

        void DisplayError(string message)
        {
            DisplayAlert("Error", message, "this is so sad :(");
        }
    }
}
