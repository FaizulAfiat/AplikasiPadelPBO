<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

    <head>

        <title>Track Health</title>

        <script src="https://cdn.tailwindcss.com"></script>

    </head>

    <body class="bg-gray-100 min-h-screen flex items-center justify-center">

        <div class="bg-white p-10 rounded-3xl shadow-xl w-[550px]">

            <h1 class="text-5xl font-black uppercase mb-8">
                TRACK HEALTH
            </h1>

            <% if (request.getParameter("success") != null) { %>

            <div class="bg-green-100 border border-green-500 text-green-700 p-4 rounded mb-6">

                Data berhasil disimpan!

            </div>

            <% }%>

            <form action="${pageContext.request.contextPath}/addHealth"
                  method="post">

                <!-- USER ID AUTO -->

                <input
                    type="hidden"
                    name="userId"
                    value="<%= session.getAttribute("userId")%>"
                    >

                <!-- RECORD DATE -->

                <div class="mb-5">

                    <label class="block font-bold mb-2">

                        Record Date

                    </label>

                    <input
                        type="date"
                        name="recordDate"
                        required
                        class="w-full border p-4 rounded-lg"
                        >

                </div>

                <!-- HEART RATE -->

                <div class="mb-5">

                    <label class="block font-bold mb-2">

                        Heart Rate

                    </label>

                    <input
                        type="number"
                        name="heartRate"
                        required
                        class="w-full border p-4 rounded-lg"
                        >

                </div>

                <!-- BMI -->

                <div class="mb-5">

                    <label class="block font-bold mb-2">

                        BMI

                    </label>

                    <input
                        type="text"
                        name="bmi"
                        required
                        class="w-full border p-4 rounded-lg"
                        >

                </div>

                <!-- STEPS -->

                <div class="mb-5">

                    <label class="block font-bold mb-2">

                        Steps

                    </label>

                    <input
                        type="number"
                        name="steps"
                        required
                        class="w-full border p-4 rounded-lg"
                        >

                </div>

                <!-- CALORIES -->

                <div class="mb-8">

                    <label class="block font-bold mb-2">

                        Calories

                    </label>

                    <input
                        type="number"
                        name="calories"
                        required
                        class="w-full border p-4 rounded-lg"
                        >

                </div>

                <!-- BUTTON -->

                <button
                    type="submit"
                    class="w-full bg-black text-white py-4 rounded-lg font-bold hover:bg-gray-800 transition">

                    Save Health Data

                </button>

            </form>

            <!-- BACK -->

            <a href="${pageContext.request.contextPath}/index.jsp"
               class="block mt-5 text-center bg-gray-200 py-3 rounded-lg font-bold hover:bg-gray-300 transition">

                Back to Dashboard

            </a>

        </div>

    </body>

</html>